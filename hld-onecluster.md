***

### 📋 Full Universe Setup (http://35.228.142.172:15433)  

***

## 🔑 Basic Information  
| **Property**          | **Value**                                                                 |
|------------------------|---------------------------------------------------------------------------|
| **Universe UUID**     | `5d77ee8d-8981-4a58-8f62-f2df0f3c805a`                                     |
| **Database Version**  | `v2025.1.0.1`                                                             |
| **Date Created**      | `August 25, 2025, 12:30 PM`                                               |
| **Encryption**        | **None**                                                                  |
| **Authentication**    | **None**                                                                  |
| **Fault Tolerance**   | **None**                                                                  |
| **Replication Factor**| `1`                                                                       |
| **Total Nodes**       | 1                                                                         |
| **Total vCPU**        | 2                                                                         |
| **Total Memory**      | 2.36 GB                                                                   |
| **Total Disk Size**   | 19.74 GB                                                                  |

***

## 🖥️ Primary Cluster Information  
| **Property**       | **Value**                                                                 |
|---------------------|---------------------------------------------------------------------------|
| **Cluster Type**   | Primary Cluster                                                            |
| **Total Nodes**    | 1                                                                          |
| **Total vCPU**     | 2                                                                          |
| **Total Memory**   | 2.36 GB                                                                    |
| **Total Disk Size**| 19.74 GB                                                                   |

***

## 🌎 Placement Information  
| **Level**       | **Value**        |
|-----------------|------------------|
| **Cloud**      | `cloud1`         |
| **Region**     | `datacenter1`    |
| **Zone**       | `rack1`          |

***

## 🖧 Node Information (datacenter1 / rack1)  
| **Node Count** | **vCPU / Node** | **RAM / Node** | **Disk / Node** |
|-----------------|-----------------|----------------|-----------------|
| 1              | 2 vCPU          | 2.36 GB        | 19.74 GB        |

***

## 🌐 Network & Ports  
| **Type**             | **Address**            | **Purpose**                       |
|-----------------------|------------------------|-----------------------------------|
| **RPC (Master)**      | `10.166.0.2:7100`     | Master internal communication      |
| **RPC (TServer)**     | `10.166.0.2:9100`     | TServer internal communication     |
| **Master Web UI**     | `http://10.166.0.2:7000` | Master Admin Dashboard          |
| **TServer Web UI**    | `http://10.166.0.2:9000` | TServer Admin Dashboard         |
| **YCQL Port**         | `10.166.0.2:9042`     | Cassandra-compatible API           |
| **YSQL Port**         | `10.166.0.2:5433`     | PostgreSQL-compatible API          |
| **Redis Port**        | `10.166.0.2:6379`     | Redis-compatible API               |

***

## ⚙️ Custom & System Flags  

### Master Flags  
| **Flag**                             | **Value**                       |
|---------------------------------------|---------------------------------|
| log_filename                          | yb-master                       |
| placement_cloud                       | cloud1                          |
| placement_region                      | datacenter1                     |
| placement_zone                        | rack1                           |
| rpc_bind_addresses                    | 10.166.0.2:7100                 |
| webserver_interface                   | 10.166.0.2                      |
| webserver_port                        | 7000                            |
| cluster_uuid                          | 8df8279d-4cf1-4adc-9636-dad9394eb380 |
| enforce_tablet_replica_limits         | true                            |
| fs_data_dirs                          | /root/var/data                  |
| instance_uuid_override                | 3e0314807db2491a8c9d6ab5c6916da3|
| master_addresses                      | 10.166.0.2:7100                 |
| master_enable_metrics_snapshotter     | true                            |
| mem_tracker_tcmalloc_gc_release_bytes | 7785930                         |
| metrics_snapshotter_tserver_metrics_whitelist | handler_latency_yb_tserver..., cpu_usage, disk_usage, node_up |
| replication_factor                    | 1                               |
| server_broadcast_addresses            | 10.166.0.2:7100                 |
| server_dump_info_path                 | /root/var/data/master-info      |
| server_tcmalloc_max_total_thread_cache_bytes | 33554432               |
| split_respects_tablet_replica_limits  | true                            |
| stop_on_parent_termination            | true                            |
| undefok                               | stop_on_parent_termination       |
| use_memory_defaults_optimized_for_ysql| true                            |
| yb_num_shards_per_tserver             | 1                               |
| ysql_num_shards_per_tserver           | 1                               |

***

### TServer Flags  
| **Flag**                             | **Value**                       |
|---------------------------------------|---------------------------------|
| log_filename                          | yb-tserver                      |
| placement_cloud                       | cloud1                          |
| placement_region                      | datacenter1                     |
| placement_zone                        | rack1                           |
| rpc_bind_addresses                    | 10.166.0.2:9100                 |
| webserver_interface                   | 10.166.0.2                      |
| webserver_port                        | 9000                            |
| enforce_tablet_replica_limits         | -                               |
| fs_data_dirs                          | /root/var/data                  |
| instance_uuid_override                | 0b88f94a685f49d393a3b1284dd14152|
| mem_tracker_tcmalloc_gc_release_bytes | 17518344                        |
| metrics_snapshotter_tserver_metrics_whitelist | handler_latency_yb_tserver..., cpu_usage, disk_usage, node_up |
| server_broadcast_addresses            | 10.166.0.2:9100                 |
| server_dump_info_path                 | /root/var/data/tserver-info     |
| server_tcmalloc_max_total_thread_cache_bytes | 43795860               |
| split_respects_tablet_replica_limits  | -                               |
| stop_on_parent_termination            | true                            |
| undefok                               | stop_on_parent_termination       |
| use_memory_defaults_optimized_for_ysql| true                            |
| yb_num_shards_per_tserver             | 1                               |
| ysql_num_shards_per_tserver           | 1                               |
| cql_proxy_bind_address                | 10.166.0.2:9042                 |
| enable_ysql_conn_mgr_stats            | false                           |
| metrics_snapshotter_interval_ms       | 11000                           |
| pgsql_proxy_bind_address              | 10.166.0.2:5433                 |
| placement_uuid                        | aa124615-6f2a-439e-bf32-4414d2d4557b |
| redis_proxy_bind_address              | 10.166.0.2:6379                 |
| start_pgsql_proxy                     | true                            |
| tserver_enable_metrics_snapshotter    | true                            |
| tserver_master_addrs                  | 10.166.0.2:7100                 |

***

# ✅ Final Summary
- **Universe = 1 node, 2 vCPU, 2.36 GB RAM, 20 GB disk**  
- **Replication factor = 1 (no redundancy, not fault-tolerant)**  
- **Supports Postgres (YSQL), Cassandra (YCQL), Redis APIs**  
- **Minimal config – dev/test setup**  
- **Open access (no auth/encryption)** – not secure for production  

***

