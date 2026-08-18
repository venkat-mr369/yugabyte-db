## YugabyteDB Administrator (DBA) — Course Content

A complete curriculum for training a working YugabyteDB DBA, organized from fundamentals through advanced Day-2 operations. This maps roughly to Yugabyte University's DBA101 → DBAO229 progression but is expanded with the details a self-study or corporate training program typically needs.

## Module 1 — Distributed SQL & YugabyteDB Foundations
- Monolithic vs. distributed SQL: why Oracle/PostgreSQL/MySQL hit ceilings; CAP, PACELC, and consistency trade-offs
- Google Spanner lineage and how YugabyteDB implements it
- YugabyteDB architecture: YB-Master vs. YB-TServer roles, tablets, tablet peers, Raft groups
- Storage layer (DocDB) built on a customized RocksDB
- Two APIs: YSQL (PostgreSQL-compatible) and YCQL (Cassandra-inspired) — when to use which
- Sharding (hash vs. range), replication factor (RF), and leader election
- Hybrid Logical Clocks (HLC) and how YugabyteDB agrees on time across nodes

## Module 2 — Installation & Cluster Creation
- Hardware sizing: CPU, RAM, disk (NVMe recommended), network requirements
- OS prep on Linux: ulimits, transparent hugepages, ntp/chrony, filesystem (xfs/ext4), swap
- Install methods: tarball, yugabyted CLI, Docker, Helm/Kubernetes operator, YugabyteDB Anywhere
- Bringing up a single-node cluster with `yugabyted`
- Building a multi-node RF=3 cluster manually with `yb-master` and `yb-tserver`
- Cloud deployments: AWS, GCP, Azure — instance types, placement groups, EBS/PD choices
- Kubernetes deployment with the YugabyteDB operator; StatefulSets, PVCs, and pod anti-affinity
- Verifying cluster health via the Master UI (port 7000) and TServer UI (port 9000)

## Module 3 — Cluster Topology & Data Placement
- Placement policy: cloud, region, zone
- Replication factor sizing (RF=3, RF=5) and fault-domain planning
- Single-region multi-zone deployments
- Multi-region synchronous replication
- Read replicas for low-latency reads
- Geo-partitioning of tables by row (row-level geo-partitioning) for data-residency requirements
- Preferred leaders and leader affinity
- Follower reads and their consistency semantics

## Module 4 — YSQL for DBAs
- PostgreSQL compatibility surface: what works, what differs, unsupported extensions
- Databases, schemas, roles, tablespaces (used to pin tables/indexes to placements)
- Tables: hash-sharded vs. range-sharded, `SPLIT INTO`, `SPLIT AT VALUES`
- Primary keys, secondary indexes (including covering indexes with `INCLUDE`)
- Colocated tables and colocated databases for small-table workloads
- Transactions: isolation levels (Read Committed, Snapshot, Serializable), retries, deadlocks
- Prepared statements, connection pooling (pgbouncer, YSQL Connection Manager)
- Extensions available (pg_stat_statements, pg_hint_plan, pgcrypto, orafce, pgvector, etc.)

## Module 5 — YCQL for DBAs (optional track)
- Keyspaces, tables, primary vs. clustering keys
- Secondary indexes, unique indexes, JSONB columns
- Consistency levels and lightweight transactions
- Differences from Apache Cassandra

## Module 6 — Security
- Authentication: password, LDAP, GSSAPI/Kerberos, JWT, client cert auth
- TLS for node-to-node and client-to-node encryption; certificate rotation
- Encryption at rest with a KMS (AWS KMS, GCP KMS, HashiCorp Vault)
- Role-based access control, row-level security, column-level privileges
- Audit logging with pgaudit
- Network hardening, port inventory (7000/7100/9000/9100/5433/9042), firewall rules

## Module 7 — Backup, Restore, and Point-in-Time Recovery
- Distributed snapshots via `yb-admin create_snapshot`
- Full and incremental backups to S3, GCS, Azure Blob, NFS
- Restore workflows and validation
- Point-in-Time Recovery (PITR) — history retention interval, granularity, limits
- `ysql_dump` / `ysql_dumpall` for logical backups
- Backup strategy: RPO/RTO planning, cross-region backup storage, testing restores regularly

## Module 8 — Replication & Disaster Recovery
- xCluster asynchronous replication: unidirectional and bidirectional
- Transactional xCluster (transactional consistency across clusters)
- Setting up, monitoring lag, and handling schema changes under xCluster
- Failover and failback procedures
- Change Data Capture (CDC) via the Debezium connector and Kafka
- DR runbook design and periodic game-day exercises

## Module 9 — Day-2 Operations
- Rolling software upgrades (minor and major) with zero downtime
- Adding and removing nodes; horizontal scale-out and scale-in
- Rebalancing tablets, moving leaders, changing placement info
- Managing tablet splits (automatic and manual)
- Certificate rotation, encryption key rotation
- OS patching under rolling maintenance
- Managing flags (`--flagfile`), gflags, and per-server overrides
- Common `yb-admin` and `yb-ts-cli` commands every DBA should know

## Module 10 — Monitoring, Alerting, and Observability
- Built-in metrics endpoints (Prometheus format)
- Prometheus + Grafana dashboards; recommended panels
- Key SLIs: latency (p99), throughput, tablet leader distribution, disk usage, compactions, WAL size, RPC queue depth
- Slow query analysis via `pg_stat_statements` and Active Session History
- Log locations, log rotation, and log aggregation (ELK, Loki, Splunk)
- Alerting patterns for leaderless tablets, under-replicated tablets, high write latency, disk pressure

## Module 11 — Performance Tuning
- Sharding strategy (hash vs. range) and its effect on hotspots
- Choosing partition and clustering keys; avoiding tablet hot-spotting
- Secondary index design and covering indexes
- Query plan reading: `EXPLAIN (ANALYZE, DIST, DEBUG)`; distributed cost model
- `pg_hint_plan` for stubborn plans
- Batching, `ysql_session_max_batch_size`, and prepared statement caching
- Connection pooling and the YSQL Connection Manager
- Compaction tuning, block cache sizing, and memory allocation
- Read replica offloading and follower reads for read-heavy workloads

## Module 12 — Migration to YugabyteDB
- YugabyteDB Voyager: assessment, schema migration, data migration, live migration with CDC
- Migrating from PostgreSQL, Oracle, MySQL, and Amazon Aurora
- Handling PostgreSQL features that don't yet exist in YSQL (workarounds)
- Cutover strategies: dual-write, shadow reads, blue/green

## Module 13 — YugabyteDB Anywhere (DBAO track)
- What Anywhere is and how it differs from open-source YugabyteDB and Aeon (managed cloud)
- Installing YBA with the YBA Installer; HA setup for the YBA controller
- Configuring cloud providers (AWS, GCP, Azure, on-prem, K8s)
- Creating and managing universes; instance types and storage classes
- Universe operations: scaling, edits, rolling upgrades, node replacement
- Backups and scheduled backups through YBA
- xCluster and DR management through the YBA UI/API
- Alerts, metrics dashboards, integrations (Slack, PagerDuty, email)
- YBA API/automation with Terraform

## Module 14 — Troubleshooting & Diagnostics
- Reading the Master UI: tablet health, under-replicated tablets, leader distribution
- TServer log analysis; common error signatures
- Diagnosing high latency: which layer (client, YSQL, DocDB, Raft, disk)
- Handling tablet leader storms and Raft election churn
- Recovering from a lost quorum
- Clock skew problems and how to detect them
- Disk full recovery, WAL/log growth issues
- Support bundle collection with `yb-admin` / YBA support bundles

## Module 15 — Automation & IaC
- Terraform provider for YugabyteDB Anywhere
- Ansible playbooks for OS prep and node provisioning
- Kubernetes operator patterns and custom resources
- CI/CD for schema changes (Sqitch, Flyway, Liquibase — with YSQL caveats)

## Module 16 — Capstone / Practical Exercises
Suggested hands-on labs that reinforce everything above:
1. Install a 3-node RF=3 cluster on Linux VMs and verify health.
2. Kill a node, watch failover, and bring it back into the quorum.
3. Deploy an application schema; create hash- and range-sharded tables and compare hotspot behavior under load with `ysql_bench` or `sysbench`.
4. Configure TLS, LDAP auth, and encryption at rest end-to-end.
5. Take a snapshot, corrupt data, and perform PITR back to a known-good time.
6. Set up xCluster between two regions; simulate a regional outage and fail over.
7. Do a rolling upgrade from one minor version to the next with zero downtime.
8. Add three nodes to scale from RF=3/3-node to RF=3/6-node and rebalance.
9. Build a Grafana dashboard from the Prometheus endpoint and wire alerts.
10. Run YugabyteDB Voyager to migrate a small PostgreSQL schema + data set.

## Recommended reference material
- Official docs: <https://docs.yugabyte.com>
- Yugabyte University (free, hands-on): <https://university.yugabyte.com> — especially the *DBA101 YugabyteDB DBA Fundamentals* and *YugabyteDB Anywhere Operations for Administrators* learning paths which cover install, security, cluster management, backups, provider configuration, universe deployment, scaling, rolling upgrades, monitoring, alerts, and troubleshooting
- YugabyteDB GitHub for release notes and architecture design docs

---
