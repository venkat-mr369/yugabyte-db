Perfect 👍 you’ve currently mixed **two styles of setup**:

1. **OS prep + systemd services installer** (clean, long script).
2. **Quick tarball installer + manual `su - yugabyte -c "yb-master …"` commands** (second half).

👉 Best practice: **separate them into two scripts**:

* **Script 1 (OS setup)**: Prepares Oracle Linux 9.5, creates user, kernel tuning, directories, systemd units. Run **once per node as root**.
* **Script 2 (DB setup)**: Handles YugabyteDB download, extract, symlink, and launches via **systemd** (not `nohup` or `&`). Run as **root** but services run as `yugabyte`.

---

## ✅ Script 1: OS Setup (`yb-os-setup.sh`)

```bash
#!/bin/bash
# YugabyteDB OS prep for Oracle Linux 9.5 (GCP)
# Run once per node as root

set -euo pipefail

YB_USER="yugabyte"
YB_BASE_DIR="/opt/yugabyte"
MASTER_DATA_DIR="/data/yb-data/master"
TSERVER_DATA_DIR="/data/yb-data/tserver"
LOG_DIR="/var/log/yugabyte"

# Install prereqs
dnf -y install wget tar xz lsof jq chrony openssl procps-ng

# Time sync
systemctl enable --now chronyd || true

# Create yugabyte user
if ! id $YB_USER >/dev/null 2>&1; then
  useradd -m -s /bin/bash $YB_USER
  echo "$YB_USER ALL=(ALL) NOPASSWD:ALL" >/etc/sudoers.d/90-yugabyte
  chmod 440 /etc/sudoers.d/90-yugabyte
fi

# Directories
mkdir -p $YB_BASE_DIR $MASTER_DATA_DIR $TSERVER_DATA_DIR $LOG_DIR
chown -R $YB_USER:$YB_USER $YB_BASE_DIR $MASTER_DATA_DIR $TSERVER_DATA_DIR $LOG_DIR

# Ulimits
cat >/etc/security/limits.d/90-yugabyte.conf <<EOF
$YB_USER soft nofile 1048576
$YB_USER hard nofile 1048576
$YB_USER soft nproc  65536
$YB_USER hard nproc  65536
$YB_USER soft memlock unlimited
$YB_USER hard memlock unlimited
EOF

# Kernel tuning
cat >/etc/sysctl.d/99-yugabyte.conf <<EOF
vm.swappiness = 1
net.core.somaxconn = 1024
EOF
sysctl --system || true

# Disable Transparent Huge Pages
cat >/etc/systemd/system/disable-thp.service <<'EOF'
[Unit]
Description=Disable Transparent Huge Pages
After=network.target

[Service]
Type=oneshot
ExecStart=/bin/sh -c 'for f in /sys/kernel/mm/transparent_hugepage/enabled /sys/kernel/mm/transparent_hugepage/defrag; do [ -f "$f" ] && echo never > "$f"; done'

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable --now disable-thp || true

echo "✅ OS setup completed. Next run yb-db-setup.sh"
```

---

## ✅ Script 2: DB Setup (`yb-db-setup.sh`)

```bash
#!/bin/bash
# YugabyteDB install & systemd services for GCP Oracle Linux 9.5
# Run as root on EACH NODE after yb-os-setup.sh

set -euo pipefail

### === Node-specific config ===
NODE_NAME="vm01"                   # vm01 | vm02 | vm03
NODE_IP="10.166.0.3"               # private IP of this node
PLACEMENT_CLOUD="gcp"
PLACEMENT_REGION="europe-north1"
PLACEMENT_ZONE="europe-north1-a"

MASTER_ADDRS=("10.166.0.3:7100" "10.148.0.2:7100" "10.138.0.2:7100")
MASTER_ADDRS_CSV=$(IFS=, ; echo "${MASTER_ADDRS[*]}")

YB_USER="yugabyte"
YB_BASE_DIR="/opt/yugabyte"
YB_TARBALL_URL="https://software.yugabyte.com/releases/2025.1.0.1/yugabyte-2025.1.0.1-b3-linux-x86_64.tar.gz"
YB_LINK_NAME="yugabyte-sw"
MASTER_DATA_DIR="/data/yb-data/master"
TSERVER_DATA_DIR="/data/yb-data/tserver"

### === Download & Extract ===
sudo -iu $YB_USER bash <<EOSUDO
set -euo pipefail
cd $YB_BASE_DIR
if [ ! -f "$(basename $YB_TARBALL_URL)" ]; then
  wget -q $YB_TARBALL_URL
fi
tar xvfz $(basename $YB_TARBALL_URL)

EXDIR=\$(ls -d yugabyte-* | head -n1)
ln -sfn "\$EXDIR" $YB_LINK_NAME

# Add PATH
grep -q "export YB_HOME=" ~/.bashrc || cat >>~/.bashrc <<'EOF'
export YB_HOME=$YB_BASE_DIR/$YB_LINK_NAME
export PATH="\$YB_HOME/bin:\$PATH"
EOF
EOSUDO

### === Systemd unit files ===
cat >/etc/systemd/system/yb-master.service <<EOF
[Unit]
Description=YugabyteDB Master
After=network.target

[Service]
User=$YB_USER
ExecStart=$YB_BASE_DIR/$YB_LINK_NAME/bin/yb-master \\
  --fs_data_dirs=$MASTER_DATA_DIR \\
  --master_addresses=$MASTER_ADDRS_CSV \\
  --rpc_bind_addresses=$NODE_IP:7100 \\
  --server_broadcast_addresses=$NODE_IP:7100 \\
  --webserver_interface=$NODE_IP --webserver_port=7000 \\
  --placement_cloud=$PLACEMENT_CLOUD --placement_region=$PLACEMENT_REGION --placement_zone=$PLACEMENT_ZONE \\
  --replication_factor=3
Restart=on-failure
LimitNOFILE=1048576

[Install]
WantedBy=multi-user.target
EOF

cat >/etc/systemd/system/yb-tserver.service <<EOF
[Unit]
Description=YugabyteDB TServer
After=yb-master.service

[Service]
User=$YB_USER
ExecStart=$YB_BASE_DIR/$YB_LINK_NAME/bin/yb-tserver \\
  --fs_data_dirs=$TSERVER_DATA_DIR \\
  --tserver_master_addrs=$MASTER_ADDRS_CSV \\
  --rpc_bind_addresses=$NODE_IP:9100 \\
  --server_broadcast_addresses=$NODE_IP:9100 \\
  --webserver_interface=$NODE_IP --webserver_port=9000 \\
  --placement_cloud=$PLACEMENT_CLOUD --placement_region=$PLACEMENT_REGION --placement_zone=$PLACEMENT_ZONE \\
  --start_pgsql_proxy --pgsql_proxy_bind_address=$NODE_IP:5433 \\
  --cql_proxy_bind_address=$NODE_IP:9042 \\
  --redis_proxy_bind_address=$NODE_IP:6379
Restart=on-failure
LimitNOFILE=1048576

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable --now yb-master
sleep 2
systemctl enable --now yb-tserver

echo "✅ YugabyteDB started on $NODE_NAME ($NODE_IP)"
echo "UI: Master http://$NODE_IP:7000  |  TServer http://$NODE_IP:9000"
```

---

## 🔑 Usage

1. On each VM:

   ```bash
   bash yb-os-setup.sh
   ```
2. Then edit **`yb-db-setup.sh`** for the correct `NODE_NAME`, `NODE_IP`, `PLACEMENT_ZONE` (per node).
3. Run it:

   ```bash
   bash yb-db-setup.sh
   ```
4. Verify cluster health from any node:

   ```bash
   su - yugabyte -c "/opt/yugabyte/yugabyte-sw/bin/yb-admin \
     --master_addresses 10.166.0.3:7100,10.148.0.2:7100,10.138.0.2:7100 list_all_masters"
   ```

---


