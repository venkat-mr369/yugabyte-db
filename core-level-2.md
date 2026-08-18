## YugabyteDB Administrator Course

Scope: Core-level DBA training. Cloud coverage limited to AWS, GCP, and YugabyteDB Aeon. Migration coverage limited to PostgreSQL → YugabyteDB. Includes an Infrastructure-as-Code module.

---

### Module 1: Introduction to YugabyteDB

* What is YugabyteDB?
* Evolution of Databases
* SQL vs NoSQL vs NewSQL (Distributed SQL)
* Why YugabyteDB?
* YugabyteDB Features
* Editions (Community, Enterprise / YugabyteDB Anywhere, YugabyteDB Aeon)
* Use Cases
* Architecture Overview
* The two APIs: YSQL (PostgreSQL-compatible) and YCQL (Cassandra-inspired) — course focuses on YSQL

---

### Module 2: Installation & Environment Setup

* Prerequisites
* Oracle Linux 9 / RHEL 9 Installation
* Install YugabyteDB (tarball, yugabyted CLI)
* Single-Node Cluster (Insecure)
* Secure vs Insecure Mode
* Single-Node Cluster (Secure)
    * TLS Certificate Architecture
    * Create CA Certificate
    * Create Node Certificate
    * Create Client Certificate
    * Start yb-master and yb-tserver Services
    * Configure Systemd Units
    * Configure Firewall (ports 5433, 9042, 7000, 7100, 9000, 9100)
* Master UI and TServer UI
* SQL Client (ysqlsh)
* Cloud install notes: AWS EC2 and GCP Compute Engine

---

### Module 3: YugabyteDB Distributed Architecture

* Distributed SQL Architecture
* Node Architecture (YB-Master and YB-TServer roles)
* Cluster Architecture
* Stores
* DocDB Key-Value Layer
* YSQL / YCQL Query Layer
* Distributed Query Execution
* Tablets (equivalent to CockroachDB ranges)
* Tablet Splits
* Tablet Merges (limitations)
* Tablet Peers and Replicas
* Tablet Leaders (equivalent to leaseholders)
* Master-based Metadata (equivalent to gossip)
* Raft Consensus
* System Catalog and Metadata Tables

**Hands-on**
* Explore Internal Metadata (`yb-admin`, `pg_catalog`, `yb_servers()`)
* Cluster Topology
* Three-Node Cluster Installation
* Cluster Verification

---

### Module 4: Security & User Management

* Users
* Password Policies
* Roles
* Role Hierarchy
* Grants
* Revokes
* RBAC
* Row-Level Security (basic)
* Column-Level Privileges
* Encryption
    * Encryption in Transit (client-to-node and node-to-node TLS)
    * Encryption at Rest (AWS KMS or GCP KMS)
* Audit Logs (pgaudit extension)
* LDAP and Certificate-based Authentication
* Security Best Practices

---

### Module 5: Distributed Storage Internals

#### Storage Engine

* DocDB Storage Engine
* RocksDB Foundation
* SSTables
* LSM Trees
* MemTables
* WAL
* Write Path
* Read Path

#### MVCC

* MVCC Architecture
* Version Storage
* Garbage Collection
* Hybrid Logical Clocks (HLC) and Timestamps
* History Retention Interval (for PITR)

#### Tablet Management

* Tablet Splits (automatic and manual)
* Manual Split with `SPLIT INTO` / `SPLIT AT VALUES`
* Leader Transfers
* Automatic Rebalancing
* Automatic Sharding (hash vs range)

#### Replication Internals

* Replication Factor (RF=3, RF=5)
* Quorum
* Leader Election
* Follower Reads (basic)
* Failover

---

### Module 6: Backup & Restore

* FULL BACKUPS (distributed snapshots via `yb-admin`)
* Incremental Backup
* RESTORE
* Point-in-Time Recovery (PITR)
* Scheduled Backups (via YugabyteDB Anywhere)
* Cloud Storage Backups (Amazon S3, Google Cloud Storage)
* Backup Encryption
* Backup Validation
* Logical Backups with `ysql_dump` / `ysql_dumpall`

---

### Module 7: Cluster Administration

* Production Checklist
    * https://docs.yugabyte.com/preview/deploy/checklist/
* Cluster Initialization & Settings
    * Overview
        * Horizontal Scaling
        * Vertical Scaling
* Cluster Configuration (gflags for master and tserver)
* Node Management
    * Adding Node
    * Removing Node
* Node Decommission (blacklisting)
* Node Recommission
* Cluster Upgrade (rolling minor and major upgrades)
* Cluster Health
* Cluster Diagnostics (managing long-running queries, `pg_stat_activity`)
* Licensing (Community vs Enterprise / YugabyteDB Anywhere)

---

### Module 8: Monitoring & Observability

* Master UI (port 7000)
* TServer UI (port 9000)
* Metrics Dashboards (Prometheus + Grafana)
* YSQL Sessions and `pg_stat_activity`
* Health Checks
* Statement & Transactions Page (via `pg_stat_statements`)
* Active Session History (ASH)
* Tablet Servers Page
* Network / RPC Metrics
* Jobs and Background Tasks
* Scheduled Backups Page (in YugabyteDB Anywhere)
* Advanced Debug Page (`/rpcz`, `/metrics`, `/varz`)
* Alerting patterns (leaderless tablets, under-replicated tablets, disk pressure)

---

### Module 9: Multi-Region Cluster [AWS or GCP]

* Placement Info (Cloud / Region / Zone)
* Localities
* Regions
* Zones
* Fault-Tolerance Levels (zone, region, cloud)
* Row-Level Geo-Partitioning (equivalent to REGIONAL BY ROW)
* Tablespace-based Table Placement (equivalent to REGIONAL BY TABLE)
* Duplicate / Read-Replica Tables for Low Latency (equivalent to GLOBAL tables)
* Read Replicas
* Preferred Leaders and Leader Affinity
* Multi-Region YSQL
* Latency Optimization

---

### Module 10: Cross-Cluster Replication (HA / DR)

* xCluster Asynchronous Replication
    * Overview
    * Configuration & Setup (Unidirectional)
    * Bidirectional Replication
    * Failover from Primary to Standby
    * Monitoring Replication Lag
* Transactional xCluster (consistency across clusters)
* Change Data Capture (CDC)
    * Overview
    * Configuration & Setup (Debezium connector)
    * Monitoring CDC Streams

---

### Module 11: Performance Tuning & Troubleshooting

* Transaction Performance
* MVCC Performance
* ACID Performance Considerations
* UPSERT Performance
* IMPORT Performance (COPY, `ysql_bench`, bulk load techniques)
* EXPORT Performance
* Index Tuning (covering indexes with `INCLUDE`)
* Query Optimization
* Query Optimizer
* Cost-Based Optimizer
* Statistics (`ANALYZE`)
* Query Plans
* `EXPLAIN`
* `EXPLAIN (ANALYZE, DIST, DEBUG)`
* Prepared Statements and Plan Caching
* Session Settings (`yb_*` and PostgreSQL GUCs)
* Statement Diagnostics
* SQL Activity Monitoring
* Hotspots
* Hot Tablets / Hot Shards
* Contention Analysis (wait events, `yb_active_session_history`)
* Leader Imbalance
* Slow Queries
* High CPU Usage
* High Memory Usage
* High Latency
* SQL Connection Performance Issues (YSQL Connection Manager, pgbouncer)

---

### Module 12: Migration to YugabyteDB (PostgreSQL only)

* PostgreSQL Compatibility (what YSQL supports and what it does not)
* YugabyteDB Voyager Overview
* Assessment Report (unsupported objects, sharding recommendations)
* Schema Migration (export, review, import)
* Data Migration (offline snapshot mode; live migration with CDC)
* Validation (row counts, checksums, smoke tests)
* Cutover Strategy (stop writes, final sync, switch application)
* Rollback Strategy
* Migration Best Practices

---

### Module 13: YugabyteDB Anywhere (Self-Managed Control Plane)

* What YBA is and when to use it
* Installing YBA with the YBA Installer
* HA Setup for the YBA Controller
* Configuring Cloud Providers (AWS, GCP, on-prem)
* Creating and Managing Universes
* Universe Operations (scaling, edits, rolling upgrades, node replacement)
* Scheduled Backups
* xCluster and DR Management from the UI
* Alerts, Metrics Dashboards, Integrations (Slack, PagerDuty, email)

---

### Module 14: YugabyteDB Aeon (Fully Managed Cloud)

* Aeon Overview
* Free Sandbox vs Dedicated Clusters
* Creating Clusters on AWS and GCP
* Fault-Tolerance Level Selection
* Network Access (allow-lists, VPC peering, AWS PrivateLink, GCP Private Service Connect)
* Database Users and Roles in Aeon
* Backups and PITR in Aeon
* Scaling (vertical and horizontal)
* Read Replicas and Multi-Region Clusters in Aeon
* Monitoring Dashboards, Alerts, and Log Export
* Aeon-specific Limits vs Self-Managed

---

### Module 15: Infrastructure as Code (IaC)

* What IaC is and why DBAs benefit from it
* Terraform Basics: providers, resources, state, plan vs apply
* Terraform AWS Provider — provision EC2 instances for a YugabyteDB cluster
* Terraform GCP Provider — provision Compute Engine instances for a YugabyteDB cluster
* Terraform Provider for YugabyteDB Aeon — create and manage Aeon clusters
* Ansible Basics: inventory, playbooks, roles
* Ansible Playbook to install YugabyteDB and start `yb-master` and `yb-tserver`
* Managing gflags with Ansible
* Storing IaC in Git and safe workflows (plan before apply, code review, state locking)

---

### Practical Labs

1. Install a single-node YugabyteDB cluster with `yugabyted` and connect using `ysqlsh`.
2. Install a three-node RF=3 cluster on AWS EC2 or GCP Compute Engine.
3. Set up TLS certificates end-to-end and enable client-to-node and node-to-node encryption.
4. Create databases, roles, users; grant and revoke privileges; enable pgaudit.
5. Take a distributed snapshot, delete data, restore, and then perform PITR.
6. Configure xCluster replication between two clusters and observe lag.
7. Add a node, watch tablets rebalance, then decommission a node.
8. Perform a rolling minor-version upgrade.
9. Set up Prometheus and Grafana; import a starter dashboard and configure alerts.
10. Run YugabyteDB Voyager to migrate a small PostgreSQL database.
11. Create an Aeon cluster on AWS or GCP; set up VPC peering; connect from a client.
12. Write a Terraform script that provisions the VMs for a three-node cluster on AWS or GCP.
13. Write an Ansible playbook that installs YugabyteDB and starts the services on those VMs.

---

### Suggested Schedule (5–6 days)

* **Day 1:** Modules 1–3 (Introduction, Installation, Distributed Architecture)
* **Day 2:** Modules 4–5 (Security, Storage Internals)
* **Day 3:** Modules 6–7 (Backup / Restore, Cluster Administration)
* **Day 4:** Modules 8–9 (Monitoring, Multi-Region)
* **Day 5:** Modules 10–12 (Cross-Cluster Replication, Performance, Migration)
* **Day 6:** Modules 13–15 (YBA, Aeon, IaC) + Labs

---

### Reference Material

* Official docs: https://docs.yugabyte.com
* Production checklist: https://docs.yugabyte.com/preview/deploy/checklist/
* Yugabyte University (free): https://university.yugabyte.com
* YugabyteDB Aeon: https://docs.yugabyte.com/preview/yugabyte-cloud/
* YugabyteDB Voyager: https://docs.yugabyte.com/preview/yugabyte-voyager/
* Terraform provider for YugabyteDB Aeon: https://registry.terraform.io/providers/yugabyte/ybm/latest
