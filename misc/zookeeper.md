# Geting started
1. Create file conf/zoo.cfg with
```
tickTime=2000
dataDir=/var/zookeeper
clientPort=2181
```
2. run server: `bin/zkServer.sh start` or  `bin/zkServer.sh start-foreground` to see logs in terminal
3. run client: `bin/zkCli.sh -server 127.0.0.1:2181` or just `bin/zkCli.sh`
4. in client terminal try commands: `help`, `ls /`, `create /zk_test my_data`, `get /zk_test` 


