Perfect 👌 You are right — if we follow the **official Yugabyte tutorial** ([link](https://docs.yugabyte.com/preview/tutorials/)), everything is shown as `yugabyte` user, not as `root`.
Best practice in production: **Do not install Yugabyte as root**. Instead:

* Create a dedicated Linux user (e.g., `yugabyte`).
* Give it `sudo` rights (so it can manage services and directories).
* Do installation and cluster setup from this user.

Let me **rework your 4-node cluster setup completely from scratch** step by step.

---

# 🛠️ Step 1: Create Yugabyte User on All Nodes

Login as `root` on each server (`10.166.0.3–6`) and run:

```bash
# Create yugabyte user
useradd -m -s /bin/bash yugabyte

# Set password
passwd yugabyte

# Give sudo privileges
usermod -aG wheel yugabyte   # (On RHEL/Oracle Linux)
# or
usermod -aG sudo yugabyte    # (On Ubuntu/Debian)
```

Verify:

```bash
su - yugabyte
whoami   # should return yugabyte
```

---

# 🛠️ Step 2: Install Dependencies

As `root` on all nodes:

```bash
yum install -y wget tar curl net-tools
```

---

# 🛠️ Step 3: Download YugabyteDB as `yugabyte` User

On each server:

```bash
su - yugabyte
wget https://downloads.yugabyte.com/releases/2025.1.0.1/yugabyte-2025.1.0.1-linux.tar.gz
tar xvf yugabyte-2025.1.0.1-linux.tar.gz
cd yugabyte-2025.1.0.1
```

Add to PATH (append to `~/.bashrc`):

```bash
echo 'export PATH=$HOME/yugabyte-2025.1.0.1/bin:$PATH' >> ~/.bashrc
source ~/.bashrc
```

---

# 🛠️ Step 4: Start YB-Master on 3 Nodes

Run as `yugabyte` user:

On **10.166.0.3**:

```bash
./bin/yb-master \
  --master_addresses=10.166.0.3:7100,10.166.0.4:7100,10.166.0.5:7100 \
  --rpc_bind_addresses=10.166.0.3:7100 \
  --webserver_interface=10.166.0.3 \
  --fs_data_dirs=/home/yugabyte/yugabyte-data/master \
  > ~/master.out 2>&1 &
```

Do the same on **10.166.0.4** and **10.166.0.5** (just replace IPs).

---

# 🛠️ Step 5: Start YB-TServer on All 4 Nodes

On **10.166.0.3**:

```bash
./bin/yb-tserver \
  --tserver_master_addrs=10.166.0.3:7100,10.166.0.4:7100,10.166.0.5:7100 \
  --rpc_bind_addresses=10.166.0.3:9100 \
  --cql_proxy_bind_address=10.166.0.3:9042 \
  --pgsql_proxy_bind_address=10.166.0.3:5433 \
  --redis_proxy_bind_address=10.166.0.3:6379 \
  --webserver_interface=10.166.0.3 \
  --fs_data_dirs=/home/yugabyte/yugabyte-data/tserver \
  > ~/tserver.out 2>&1 &
```

Repeat on **10.166.0.4, 10.166.0.5, 10.166.0.6** with their respective IPs.

---

# 🛠️ Step 6: Verify Cluster

From **any node** (as `yugabyte`):

```bash
./bin/yb-admin --master_addresses 10.166.0.3:7100,10.166.0.4:7100,10.166.0.5:7100 list_all_masters
./bin/yb-admin --master_addresses 10.166.0.3:7100,10.166.0.4:7100,10.166.0.5:7100 list_all_tablet_servers
```

Expected:

* 3 Masters (1 leader, 2 followers)
* 4 Tablet Servers

Check UIs:

* Master UI → `http://10.166.0.3:7000`
* TServer UI → `http://10.166.0.3:9000`

---

# 🛠️ Step 7: Connect Clients

* **Postgres API (YSQL)**:

  ```bash
  ysqlsh -h 10.166.0.3 -p 5433
  ```
* **Cassandra API (YCQL)**:

  ```bash
  ycqlsh 10.166.0.3 9042
  ```
* **Redis API (YEDIS)**:

  ```bash
  redis-cli -h 10.166.0.3 -p 6379
  ```

---

## ✅ Final Layout (with yugabyte user)

| Node (IP)  | Role(s)          | Ports Used                               |
| ---------- | ---------------- | ---------------------------------------- |
| 10.166.0.3 | Master + TServer | 7100, 7000, 9100, 9000, 5433, 9042, 6379 |
| 10.166.0.4 | Master + TServer | 7100, 7000, 9100, 9000, 5433, 9042, 6379 |
| 10.166.0.5 | Master + TServer | 7100, 7000, 9100, 9000, 5433, 9042, 6379 |
| 10.166.0.6 | TServer only     | 9100, 9000, 5433, 9042, 6379             |

---

