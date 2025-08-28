production-runbook, step-by-step for a 3-node YugabyteDB cluster on **Oracle Linux 9.5** across **GCP** using your exact version. 
it simple and aligned with this commands (`su - yugabyte`, `wget`, `tar`, softlink).

---

### 0) Topology

| Node | Zone              | Internal IP |
| ---- | ----------------- | ----------- |
| vm01 | europe-north1-a   | 10.166.0.3  |
| vm02 | asia-southeast1-b | 10.148.0.2  |
| vm03 | us-west1-b        | 10.138.0.2  |

Master RPC: `7100` • Master UI: `7000`
TServer RPC: `9100` • TServer UI: `9000`
YSQL: `5433` • YCQL: `9042` • YEDIS: `6379`

Replication factor: **3** (RF=3)

### Explanations about ports
Great question 👍 — now that I see both your **OS setup** and **DB setup** scripts, I can tell you exactly which ports must be enabled between nodes (east-west traffic) and which ones can be exposed to clients (north-south traffic).

---

## 🔑 YugabyteDB Ports (from your `yb-master` + `yb-tserver` configs)

### **Master (yb-master)**

* **7100** → gRPC / RPC communication between masters (internal cluster traffic)
* **7000** → Web UI for master (HTTP, optional external access for monitoring)

### **Tablet Server (yb-tserver)**

* **9100** → gRPC / RPC communication between tservers and masters (internal cluster traffic)
* **9000** → Web UI for tserver (HTTP, optional external access for monitoring)

### **Client APIs (app-facing)**

* **5433** → YSQL (PostgreSQL-compatible SQL)
* **9042** → YCQL (Cassandra-compatible)
* **6379** → YEDIS (Redis-compatible)

---

## ✅ Ports to **enable between nodes** (east-west, private VPC)

These must be **open between vm01, vm02, vm03** in your GCP VPC security groups/firewall:

* **7100 (master RPC)**
* **9100 (tserver RPC)**

*(These are the lifeline ports — without them, masters/tservers cannot form a cluster.)*

---

## ✅ Ports to **allow for operators/admins** (north-south, optional external access)

For DBAs and DevOps to check cluster health:

* **7000 (master UI)**
* **9000 (tserver UI)**

👉 These are **optional** and should normally be limited to your VPN or trusted IPs.

---

## ✅ Ports to **allow for applications** (north-south, external access)

For client traffic from your applications:

* **5433 (YSQL / PostgreSQL wire protocol)**
* **9042 (YCQL / Cassandra protocol)**
* **6379 (YEDIS / Redis protocol)**

👉 Open only the ones your applications actually use. For example:

* If only YSQL is used → only **5433** needs to be opened.
* YCQL and Redis ports can stay closed unless you need them.

---

## 🔒 Suggested GCP Firewall Rules

1. **Cluster-internal communication (must-have)**

   * Source: `10.166.0.0/16` (your GCP VPC subnet, adjust as needed)
   * Ports: `7100,9100` (TCP)

2. **Admin/Monitoring (optional)**

   * Source: your VPN or trusted IPs
   * Ports: `7000,9000` (TCP)

3. **Application Clients (selective)**

   * Source: app servers / app network
   * Ports: whichever DB APIs you use (`5433`, `9042`, `6379`)
---
📌 **Summary:**

* **Internal cluster (node-to-node)**: `7100`, `9100`
* **Admin UIs**: `7000`, `9000`
* **Client apps**: `5433`, `9042`, `6379`
---

### 1) GCP firewall (one-time)

(If firewalld on the VMs is disabled and you rely on GCP firewall only.)

```bash
# Give all three instances the same network tag
gcloud compute instances add-tags vm01 --zone=europe-north1-a --tags=yb-cluster
gcloud compute instances add-tags vm02 --zone=asia-southeast1-b --tags=yb-cluster
gcloud compute instances add-tags vm03 --zone=us-west1-b         --tags=yb-cluster

# Allow intra-cluster ports between these tagged instances
gcloud compute firewall-rules create yb-internal \
  --network=default \
  --direction=INGRESS \
  --action=ALLOW \
  --rules=tcp:7000,tcp:7100,tcp:9000,tcp:9100,tcp:5433,tcp:9042,tcp:6379 \
  --source-tags=yb-cluster \
  --target-tags=yb-cluster
```

> If you’d rather lock to VPC ranges instead of tags, use `--source-ranges=10.0.0.0/8`.

---

### 2) OS prep on **all three** VMs (as root)

```bash
# Become root if not already
sudo -i

# Packages
dnf -y install wget tar xz lsof jq chrony openssl procps-ng

# Ensure time sync
systemctl enable --now chronyd

# Create yugabyte user
id yugabyte || useradd -m -s /bin/bash yugabyte
echo 'yugabyte ALL=(ALL) NOPASSWD:ALL' >/etc/sudoers.d/90-yugabyte
chmod 440 /etc/sudoers.d/90-yugabyte

# Directories
mkdir -p /opt/yugabyte /data/yb-data/master /data/yb-data/tserver /var/log/yugabyte
chown -R yugabyte:yugabyte /opt/yugabyte /data/yb-data /var/log/yugabyte

# Ulimits
cat >/etc/security/limits.d/90-yugabyte.conf <<'EOF'
yugabyte soft nofile 1048576
yugabyte hard nofile 1048576
yugabyte soft nproc  65536
yugabyte hard nproc  65536
yugabyte soft memlock unlimited
yugabyte hard memlock unlimited
EOF

# Kernel tuning
cat >/etc/sysctl.d/99-yugabyte.conf <<'EOF'
vm.swappiness = 1
net.core.somaxconn = 1024
EOF
sysctl --system

# (Optional) Disable THP at boot (recommended for DBs)
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
systemctl enable --now disable-thp

# If you prefer to rely solely on GCP firewall, you can disable the local firewall:
# systemctl disable --now firewalld
```

---

### 3) Install Yugabyte (as `yugabyte` on **each** VM)

```bash
su - yugabyte

cd /opt/yugabyte

# Download your exact build
wget https://software.yugabyte.com/releases/2025.1.0.1/yugabyte-2025.1.0.1-b3-linux-x86_64.tar.gz

# Extract
tar xvfz yugabyte-2025.1.0.1-b3-linux-x86_64.tar.gz

# The extract creates: yugabyte-2025.1.0.1/
# Create soft link exactly as you asked
ln -s yugabyte-2025.1.0.1 yugabyte-sw

# Add env for convenience
cat >>~/.bashrc <<'EOF'
export YB_HOME=/opt/yugabyte/yugabyte-sw
export PATH="$YB_HOME/bin:$PATH"
EOF
source ~/.bashrc
```

---

### 4) Systemd units (per-node specifics)

Common master list (same on all nodes):

```
10.166.0.3:7100,10.148.0.2:7100,10.138.0.2:7100
```

Create **on each node** (as root): two unit files: `yb-master.service` and `yb-tserver.service`, with the correct IP + region/zone for that node.

#### vm01 (europe-north1-a • 10.166.0.3)

```bash
sudo -i
cat >/etc/systemd/system/yb-master.service <<'EOF'
[Unit]
Description=YugabyteDB Master
After=network.target

[Service]
Type=simple
User=yugabyte
LimitNOFILE=1048576
ExecStart=/opt/yugabyte/yugabyte-sw/bin/yb-master \
  --fs_data_dirs=/data/yb-data/master \
  --master_addresses=10.166.0.3:7100,10.148.0.2:7100,10.138.0.2:7100 \
  --rpc_bind_addresses=10.166.0.3:7100 \
  --server_broadcast_addresses=10.166.0.3:7100 \
  --webserver_interface=10.166.0.3 \
  --webserver_port=7000 \
  --placement_cloud=gcp --placement_region=europe-north1 --placement_zone=europe-north1-a \
  --replication_factor=3
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

cat >/etc/systemd/system/yb-tserver.service <<'EOF'
[Unit]
Description=YugabyteDB TServer
After=yb-master.service

[Service]
Type=simple
User=yugabyte
LimitNOFILE=1048576
ExecStart=/opt/yugabyte/yugabyte-sw/bin/yb-tserver \
  --fs_data_dirs=/data/yb-data/tserver \
  --tserver_master_addrs=10.166.0.3:7100,10.148.0.2:7100,10.138.0.2:7100 \
  --rpc_bind_addresses=10.166.0.3:9100 \
  --server_broadcast_addresses=10.166.0.3:9100 \
  --webserver_interface=10.166.0.3 \
  --webserver_port=9000 \
  --placement_cloud=gcp --placement_region=europe-north1 --placement_zone=europe-north1-a \
  --start_pgsql_proxy \
  --pgsql_proxy_bind_address=10.166.0.3:5433 \
  --cql_proxy_bind_address=10.166.0.3:9042 \
  --redis_proxy_bind_address=10.166.0.3:6379
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF
```

#### vm02 (asia-southeast1-b • 10.148.0.2)

```bash
sudo -i
cat >/etc/systemd/system/yb-master.service <<'EOF'
[Unit]
Description=YugabyteDB Master
After=network.target

[Service]
Type=simple
User=yugabyte
LimitNOFILE=1048576
ExecStart=/opt/yugabyte/yugabyte-sw/bin/yb-master \
  --fs_data_dirs=/data/yb-data/master \
  --master_addresses=10.166.0.3:7100,10.148.0.2:7100,10.138.0.2:7100 \
  --rpc_bind_addresses=10.148.0.2:7100 \
  --server_broadcast_addresses=10.148.0.2:7100 \
  --webserver_interface=10.148.0.2 \
  --webserver_port=7000 \
  --placement_cloud=gcp --placement_region=asia-southeast1 --placement_zone=asia-southeast1-b \
  --replication_factor=3
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

cat >/etc/systemd/system/yb-tserver.service <<'EOF'
[Unit]
Description=YugabyteDB TServer
After=yb-master.service

[Service]
Type=simple
User=yugabyte
LimitNOFILE=1048576
ExecStart=/opt/yugabyte/yugabyte-sw/bin/yb-tserver \
  --fs_data_dirs=/data/yb-data/tserver \
  --tserver_master_addrs=10.166.0.3:7100,10.148.0.2:7100,10.138.0.2:7100 \
  --rpc_bind_addresses=10.148.0.2:9100 \
  --server_broadcast_addresses=10.148.0.2:9100 \
  --webserver_interface=10.148.0.2 \
  --webserver_port=9000 \
  --placement_cloud=gcp --placement_region=asia-southeast1 --placement_zone=asia-southeast1-b \
  --start_pgsql_proxy \
  --pgsql_proxy_bind_address=10.148.0.2:5433 \
  --cql_proxy_bind_address=10.148.0.2:9042 \
  --redis_proxy_bind_address=10.148.0.2:6379
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF
```

#### vm03 (us-west1-b • 10.138.0.2)

```bash
sudo -i
cat >/etc/systemd/system/yb-master.service <<'EOF'
[Unit]
Description=YugabyteDB Master
After=network.target

[Service]
Type=simple
User=yugabyte
LimitNOFILE=1048576
ExecStart=/opt/yugabyte/yugabyte-sw/bin/yb-master \
  --fs_data_dirs=/data/yb-data/master \
  --master_addresses=10.166.0.3:7100,10.148.0.2:7100,10.138.0.2:7100 \
  --rpc_bind_addresses=10.138.0.2:7100 \
  --server_broadcast_addresses=10.138.0.2:7100 \
  --webserver_interface=10.138.0.2 \
  --webserver_port=7000 \
  --placement_cloud=gcp --placement_region=us-west1 --placement_zone=us-west1-b \
  --replication_factor=3
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

cat >/etc/systemd/system/yb-tserver.service <<'EOF'
[Unit]
Description=YugabyteDB TServer
After=yb-master.service

[Service]
Type=simple
User=yugabyte
LimitNOFILE=1048576
ExecStart=/opt/yugabyte/yugabyte-sw/bin/yb-tserver \
  --fs_data_dirs=/data/yb-data/tserver \
  --tserver_master_addrs=10.166.0.3:7100,10.148.0.2:7100,10.138.0.2:7100 \
  --rpc_bind_addresses=10.138.0.2:9100 \
  --server_broadcast_addresses=10.138.0.2:9100 \
  --webserver_interface=10.138.0.2 \
  --webserver_port=9000 \
  --placement_cloud=gcp --placement_region=us-west1 --placement_zone=us-west1-b \
  --start_pgsql_proxy \
  --pgsql_proxy_bind_address=10.138.0.2:5433 \
  --cql_proxy_bind_address=10.138.0.2:9042 \
  --redis_proxy_bind_address=10.138.0.2:6379
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF
```

---

### 5) Start services (masters first, then tservers)

On **each node**:

```bash
sudo systemctl daemon-reload

# Start masters first on all 3 nodes
sudo systemctl enable --now yb-master
sudo systemctl status yb-master --no-pager

# Then start tservers on all 3 nodes
sudo systemctl enable --now yb-tserver
sudo systemctl status yb-tserver --no-pager
```

---

### 6) Verify cluster health

From any node as `yugabyte`:

```bash
su - yugabyte

# Master/TServer UIs (internal):
# http://10.166.0.3:7000 , http://10.148.0.2:7000 , http://10.138.0.2:7000
# http://10.166.0.3:9000 , http://10.148.0.2:9000 , http://10.138.0.2:9000

# CLI verification
yb-admin --master_addresses 10.166.0.3:7100,10.148.0.2:7100,10.138.0.2:7100 list_all_masters
yb-admin --master_addresses 10.166.0.3:7100,10.148.0.2:7100,10.138.0.2:7100 list_all_tablet_servers
```

Quick YSQL test:

```bash
ysqlsh -h 10.166.0.3 -p 5433 -U yugabyte -c "select version();"
ysqlsh -h 10.166.0.3 -p 5433 -U yugabyte -c "create database demo;"
ysqlsh -h 10.166.0.3 -p 5433 -U yugabyte -d demo -c "create table t(id int primary key, v text); insert into t values (1,'hello'); select * from t;"
```

Quick YCQL test:

```bash
ycqlsh 10.166.0.3 9042 -e "create keyspace ks with replication = {'class':'SimpleStrategy','replication_factor':3}; create table ks.t(id int primary key, v text); insert into ks.t(id,v) values (1,'hi'); select * from ks.t;"
```

---

### 7) Operate

**Stop/Start:**

```bash
sudo systemctl stop yb-tserver
sudo systemctl stop yb-master
sudo systemctl start yb-master
sudo systemctl start yb-tserver
```

**Logs:**

```
/var/log/yugabyte/*  (or journalctl -u yb-master -u yb-tserver)
```

**Upgrade (future builds):**

```bash
# As yugabyte on each node:
cd /opt/yugabyte
wget https://software.yugabyte.com/releases/<new>/yugabyte-<new>-linux-x86_64.tar.gz
tar xvfz yugabyte-<new>-linux-x86_64.tar.gz
ln -sfn yugabyte-<new> yugabyte-sw   # atomically switch symlink
sudo systemctl restart yb-master yb-tserver
```

---

#### Notes & tips

* Cross-region 3-node RF=3 means higher write latency (majority quorum across continents). For lower latency, deploy 3 nodes in one region (or 5 nodes across 3 regions).
* The flags `--placement_cloud/region/zone` help the cluster place tablets appropriately; you can also fine-tune leader placement later with `yb-admin modify_placement_info`.
* For external client access, add separate GCP firewall rules and (optionally) bind proxies on an external interface — but prefer private/internal access.


