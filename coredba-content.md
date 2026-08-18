## YugabyteDB Core DBA — Course Content

## Module 1 — Distributed SQL & YugabyteDB Foundations
- Monolithic vs. distributed SQL: why PostgreSQL/Oracle/MySQL hit ceilings; CAP and PACELC trade-offs
- Google Spanner lineage and how YugabyteDB implements it
- Architecture: YB-Master vs. YB-TServer roles, tablets, tablet peers, Raft groups
- Storage layer (DocDB) built on a customized RocksDB
- Two APIs: YSQL (PostgreSQL-compatible) and YCQL — when to use which (DBA track stays YSQL-focused)
- Sharding (hash vs. range), replication factor, leader election
- Hybrid Logical Clocks (HLC) and cluster-wide time agreement

## Module 2 — Installation & Cluster Creation
- Hardware sizing: CPU, RAM, NVMe disk, network
- Linux OS prep: ulimits, transparent hugepages, chrony/ntp, xfs/ext4, swap
- Install methods relevant to a DBA: tarball, `yugabyted` CLI, YugabyteDB Anywhere
- Single-node bring-up with `yugabyted`
- Multi-node RF=3 cluster built manually with `yb-master` and `yb-tserver`
- AWS deployments: EC2 instance families, EBS (gp3/io2) vs. instance-store, placement groups, security groups, cross-AZ latency
- GCP deployments: Compute Engine machine types, PD-SSD vs. Local SSD, zones and regions, VPC firewall rules
- Verifying cluster health via Master UI (7000) and TServer UI (9000)

## Module 3 — Cluster Topology & Data Placement
- Placement policy: cloud, region, zone
- Replication factor sizing (RF=3, RF=5) and fault-domain planning
- Single-region multi-zone deployments
- Multi-region synchronous replication
- Read replicas for low-latency reads
- Row-level geo-partitioning for data-residency requirements
- Preferred leaders and leader affinity
- Follower reads and their consistency semantics

## Module 4 — YSQL for DBAs
- PostgreSQL compatibility surface: what works, what differs, unsupported features
- Databases, schemas, roles, tablespaces (used to pin tables/indexes to placements)
- Tables: hash-sharded vs. range-sharded, `SPLIT INTO`, `SPLIT AT VALUES`
- Primary keys, secondary indexes (including covering indexes with `INCLUDE`)
- Colocated tables and colocated databases for small-table workloads
- Transactions: Read Committed, Snapshot, Serializable; retries and deadlocks
- Prepared statements and connection pooling (pgbouncer, YSQL Connection Manager)
- Useful extensions: pg_stat_statements, pg_hint_plan, pgcrypto, pgaudit, pgvector

## Module 5 — Security
- Authentication: password, LDAP, GSSAPI/Kerberos, JWT, client certificate auth
- TLS for node-to-node and client-to-node; certificate rotation
- Encryption at rest with AWS KMS or GCP KMS
- Role-based access control, row-level security, column-level privileges
- Audit logging with pgaudit
- Port inventory (7000/7100/9000/9100/5433/9042) and firewall hardening

## Module 6 — Backup, Restore, and PITR
- Distributed snapshots via `yb-admin create_snapshot`
- Full and incremental backups to S3 and GCS
- Restore workflows and validation
- Point-in-Time Recovery: history retention interval, granularity, limits
- `ysql_dump` / `ysql_dumpall` for logical backups
- Backup strategy: RPO/RTO planning, cross-region storage, restore drills

## Module 7 — Replication & Disaster Recovery
- xCluster asynchronous replication: unidirectional and bidirectional
- Transactional xCluster for cross-cluster consistency
- Setup, lag monitoring, schema-change handling
- Failover and failback runbooks
- Change Data Capture (CDC) via the Debezium connector
- DR planning and periodic game-days

## Module 8 — Day-2 Operations
- Rolling software upgrades (minor and major) with zero downtime
- Adding and removing nodes; horizontal scale-out and scale-in
- Rebalancing tablets, moving leaders, changing placement info
- Automatic and manual tablet splits
- Certificate rotation and encryption key rotation
- OS patching under rolling maintenance
- Managing gflags and per-server overrides
- Essential `yb-admin` and `yb-ts-cli` commands

## Module 9 — Monitoring, Alerting, and Observability
- Built-in Prometheus metrics endpoints
- Prometheus + Grafana dashboards; recommended panels
- Key SLIs: p99 latency, throughput, leader distribution, disk usage, compactions, WAL size, RPC queue depth
- Slow-query analysis with `pg_stat_statements` and Active Session History
- Log locations, rotation, and aggregation
- Alerting patterns: leaderless tablets, under-replicated tablets, high write latency, disk pressure

## Module 10 — Performance Tuning
- Sharding strategy (hash vs. range) and hotspot avoidance
- Partition and clustering key design
- Secondary index and covering index design
- Reading distributed plans: `EXPLAIN (ANALYZE, DIST, DEBUG)`
- `pg_hint_plan` for stubborn plans
- Batching, `ysql_session_max_batch_size`, prepared statement caching
- Connection pooling and YSQL Connection Manager sizing
- Compaction tuning, block cache sizing, memory allocation
- Read replicas and follower reads for read-heavy workloads

## Module 11 — Migration from PostgreSQL
- YugabyteDB Voyager overview: assess, export schema, export data, import, live migration
- Assessment report: unsupported objects, sharding recommendations, effort estimate
- Schema conversion: sequences → hash-sharded alternatives, extensions, unsupported types
- Data export/import modes: offline snapshot vs. live (CDC-based) migration
- Handling PostgreSQL features with YSQL gaps and their workarounds
- Cutover strategies: dual-write, shadow reads, blue/green
- Post-migration validation: row counts, checksums, application smoke tests

## Module 12 — YugabyteDB Anywhere (self-managed control plane)
- What YBA is; how it differs from open-source YugabyteDB and Aeon
- Installing YBA with the YBA Installer; HA setup for the YBA controller
- Configuring cloud providers: AWS and GCP (on-prem provider as a bonus)
- Creating and managing universes; instance types and storage classes
- Universe operations: scaling, edits, rolling upgrades, node replacement
- Scheduled backups through YBA
- xCluster and DR management through the YBA UI
- Alerts, metrics dashboards, integrations (Slack, PagerDuty, email)

## Module 13 — YugabyteDB Aeon (fully managed cloud)
- Aeon overview: free sandbox vs. dedicated clusters
- Creating clusters on AWS and GCP; region/zone selection and fault-tolerance levels
- VPC peering and private service connect (AWS PrivateLink, GCP PSC)
- Network allow-lists, database users, and roles in Aeon
- Backups, PITR, and scheduled backup policies in Aeon
- Scaling: vertical (node size) and horizontal (node count)
- Read replicas and multi-region clusters in Aeon
- Monitoring dashboards, alerts, and log export
- Aeon-specific limits vs. self-managed YugabyteDB

## Module 14 — Troubleshooting & Diagnostics
- Reading the Master UI: tablet health, under-replicated tablets, leader distribution
- TServer log analysis and common error signatures
- Diagnosing high latency by layer (client → YSQL → DocDB → Raft → disk)
- Handling tablet leader storms and Raft election churn
- Recovering from a lost quorum
- Detecting and resolving clock skew
- Disk-full recovery, WAL/log growth issues
- Support bundle collection with `yb-admin` and YBA support bundles

## Module 15 — Capstone / Practical Labs
1. Install a 3-node RF=3 cluster on Linux VMs (AWS or GCP) and verify health.
2. Kill a node, watch failover, and rejoin the quorum.
3. Create hash- and range-sharded tables and compare hotspot behavior under `ysql_bench` load.
4. Configure TLS, LDAP auth, and encryption at rest end-to-end.
5. Take a snapshot, corrupt data, and PITR back to a known-good time.
6. Set up xCluster between two regions; simulate a regional outage and fail over.
7. Perform a rolling minor-version upgrade with zero downtime.
8. Scale from 3 to 6 nodes and rebalance tablets.
9. Build a Grafana dashboard from the Prometheus endpoint and wire alerts.
10. Run YugabyteDB Voyager end-to-end to migrate a PostgreSQL schema and data set into a YugabyteDB cluster.
11. Provision an Aeon cluster on AWS or GCP, set up VPC peering, and connect a client.

## Reference material
- Official docs: <https://docs.yugabyte.com>
- Yugabyte University: DBA101 (core DBA) and the Anywhere Operations learning path
- Aeon docs: <https://docs.yugabyte.com/preview/yugabyte-cloud/>
- YugabyteDB Voyager docs: <https://docs.yugabyte.com/preview/yugabyte-voyager/>

---

