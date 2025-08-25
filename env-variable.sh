# YugabyteDB Installation from root user

wget https://software.yugabyte.com/releases/2025.1.0.1/yugabyte-2025.1.0.1-b3-linux-x86_64.tar.gz
tar xvfz yugabyte-2025.1.0.1-b3-linux-x86_64.tar.gz && cd yugabyte-2025.1.0.1/
./bin/post_install.sh
./bin/yugabyted start


# YugabyteDB environment variable setup
# Add to ~/.bash_profile, ~/.profile, or ~/.bashrc

# JDBC connection URL for YugabyteDB
export YB_JDBC_URL="jdbc:postgresql://10.166.0.2:5433/yugabyte?user=yugabyte&password=yugabyte"

# YugabyteDB Data Directory
export YB_DATA_DIR="/root/var/data"

# YugabyteDB Log Directory
export YB_LOG_DIR="/root/var/logs"

# YugabyteDB Universe UUID
export YB_UNIVERSE_UUID="8df8279d-4cf1-4adc-9636-dad9394eb380"

# YugabyteDB UI URL (for convenience)
export YB_UI_URL="http://10.166.0.2:15433"

# YSQL shell command helper
export YB_YSQLSH="bin/ysqlsh -h 10.166.0.2  -U yugabyte -d yugabyte"

# YCQL shell command helper
export YB_YCQLSH="bin/ycqlsh 10.166.0.2 9042 -u cassandra"
