summarizes your YugabyteDB cluster’s physical and logical node distribution using the provided IPs, host names, and operating system.

### Yugabyte Cluster Nodes 

| **Node IP**    | **Host Name** | **OS**         | **Role**             |
|----------------|---------------|----------------|----------------------|
| 10.166.0.3     | VM01          | Oracle Linux   | YugabyteDB Node      |
| 10.166.0.4     | VM02          | Oracle Linux   | YugabyteDB Node      |
| 10.166.0.5     | VM03          | Oracle Linux   | YugabyteDB Node      |

***

### 🚀 YugabyteDB 3-Node Cluster Setup (Oracle Linux / RHEL)

#### 🛠️ Step 1: Create `yugabyte` User

Login as `root` on **each server** (`10.166.0.3–5`):

```bash
# Create yugabyte user
useradd -m -s /bin/bash yugabyte

# Set password
passwd yugabyte

# Give sudo privileges
usermod -aG wheel yugabyte   # (For RHEL / Oracle Linux)
# or
usermod -aG sudo yugabyte    # (For Ubuntu / Debian)
```

✅ Verify:

```bash
su - yugabyte
whoami   # should return "yugabyte"
```

---

## 🛠️ Step 2: Install Dependencies

As `root` on all 3 nodes:

```bash
yum install -y wget tar curl net-tools
```

---

## 🛠️ Step 3: Download YugabyteDB (as yugabyte user)

On each server:

```bash
su - yugabyte

wget https://downloads.yugabyte.com/releases/2025.1.0.1/yugabyte-2025.1.0.1-linux.tar.gz
tar xvf yugabyte-2025.1.0.1-linux.tar.gz
cd yugabyte-2025.1.0.1
```

Add to PATH:

```bash
echo 'export PATH=$HOME/yugabyte-2025.1.0.1/bin:$PATH' >> ~/.bashrc
source ~/.bashrc
```

---

## ⚙️ Step 4: Create Data Directories

On **all 3 servers**:

```bash
mkdir -p /home/yugabyte/yugabyte-data/master
mkdir -p /home/yugabyte/yugabyte-data/tserver
```

---

## ⚙️ Step 5: Systemd Unit Files

As **root**, create the following on **all 3 servers**:

---

### 📌 `/etc/systemd/system/yb-master.service`

```ini
[Unit]
Description=YugabyteDB Master
After=network.target

[Service]
User=yugabyte
LimitNOFILE=1048576
ExecStart=/home/yugabyte/yugabyte-2025.1.0.1/bin/yb-master \
  --master_addresses=10.166.0.3:7100,10.166.0.4:7100,10.166.0.5:7100 \
  --rpc_bind_addresses=%H:7100 \
  --webserver_interface=%H \
  --fs_data_dirs=/home/yugabyte/yugabyte-data/master
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
```

---

### 📌 `/etc/systemd/system/yb-tserver.service`

```ini
[Unit]
Description=YugabyteDB TServer
After=network.target

[Service]
User=yugabyte
LimitNOFILE=1048576
ExecStart=/home/yugabyte/yugabyte-2025.1.0.1/bin/yb-tserver \
  --tserver_master_addrs=10.166.0.3:7100,10.166.0.4:7100,10.166.0.5:7100 \
  --rpc_bind_addresses=%H:9100 \
  --cql_proxy_bind_address=%H:9042 \
  --pgsql_proxy_bind_address=%H:5433 \
  --redis_proxy_bind_address=%H:6379 \
  --webserver_interface=%H \
  --fs_data_dirs=/home/yugabyte/yugabyte-data/tserver
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
```

---

## ⚙️ Step 6: Start & Enable Services

On **each node** (`root`):

```bash
systemctl daemon-reload
systemctl enable yb-master
systemctl enable yb-tserver

systemctl start yb-master
systemctl start yb-tserver
```

---

## ⚙️ Step 7: Verify Cluster

### Service check

```bash
systemctl status yb-master
systemctl status yb-tserver
```

### Cluster verification (run on any node as `yugabyte`):

```bash
yb-admin \
  --master_addresses 10.166.0.3:7100,10.166.0.4:7100,10.166.0.5:7100 list_all_masters

yb-admin \
  --master_addresses 10.166.0.3:7100,10.166.0.4:7100,10.166.0.5:7100 list_all_tablet_servers
```

---

## ⚙️ Step 8: Web Interfaces

* Master UI → `http://<ip>:7000`
* TServer UI → `http://<ip>:9000`

---

# ✅ Final Layout (3-Node Cluster)

| Node (IP)  | Roles            | Ports Used                               |
| ---------- | ---------------- | ---------------------------------------- |
| 10.166.0.3 | Master + TServer | 7100, 7000, 9100, 9000, 5433, 9042, 6379 |
| 10.166.0.4 | Master + TServer | 7100, 7000, 9100, 9000, 5433, 9042, 6379 |
| 10.166.0.5 | Master + TServer | 7100, 7000, 9100, 9000, 5433, 9042, 6379 |

---

👉 This is now **cleaned up for only 3 nodes**.
Would you like me to also prepare a **step-by-step shell script** (`setup_yugabyte.sh`) so you can just run it on each server instead of copy-pasting?
