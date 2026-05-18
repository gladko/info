Алгоритмы консенсуса Paxos, Raft и Zab в распределённых системах - https://habr.com/ru/articles/903792/


# ZooKeeper

ZooKeeper itself is a centralized service for maintaining configuration information, naming, providing distributed synchronization, and providing group services. It is designed with the assumption that there is a cluster of servers called a ZooKeeper ensemble to provide reliability and availability.

### Configuration:
1. Create a Configuration File:
  - Within the extracted ZooKeeper directory, you will find a conf directory. Copy zoo_sample.cfg to zoo.cfg. This is the main configuration file for ZooKeeper.
2. Edit zoo.cfg:
  - Open zoo.cfg in a text editor and ensure the following minimal configuration:
```   
properties
     tickTime=2000
     dataDir=/path/to/zookeeper/data
     clientPort=2181
```
where
  - tickTime: The basic time unit in milliseconds used by ZooKeeper.
  - dataDir: The directory where ZooKeeper will store its data. Ensure this directory exists.
  - clientPort: The port on which ZooKeeper will listen for client connections (default is 2181).
3. (Optional) Setup a Multi-Server Ensemble:
  - If you are setting up a cluster, you need to add server details to the zoo.cfg file.
  - Example for a 3-node setup:
```
properties
     server.1=host1:2888:3888
     server.2=host2:2888:3888
     server.3=host3:2888:3888
```     
### Start ZooKeeper Server:
  - Linux/Unix/MacOS:  `./zkServer.sh start`
  - Windows:  `zkServer.cmd`

./zkServer.sh status

Once started, ZooKeeper will listen for client connections on the specified port (default is 2181). You can connect to it using the zkCli.sh tool in the bin directory for basic CLI operations.


# Zookeeper Vs eureka
When choosing between Apache ZooKeeper and Netflix Eureka for service discovery and registration in a new application, several factors should be considered. Both tools serve the purpose of service discovery, but they have different strengths, weaknesses, and use cases. Here are some points to help guide your decision:
### Apache ZooKeeper
Pros:
1. Mature and Stable: ZooKeeper is a well-established project, widely used in the industry for maintaining configuration information, offering distributed synchronization, and providing naming services.
 
2. Resiliency and Consistency: It is designed to provide high availability through leader election and is strong in terms of consistency due to its use of the "ZAB" protocol (ZooKeeper Atomic Broadcast).
3. Multi-purpose: Beyond service discovery, ZooKeeper's capabilities extend to leader election, distributed lock services, and more complex coordination scenarios.
4. Ecosystem: ZooKeeper is used as a foundational element for other distributed systems, like Apache Kafka and HBase.
Cons:
1. Complexity: Setting up and managing a ZooKeeper cluster can be complex and may require more operational overhead compared to Eureka.
2. APIs and Integration: The APIs are lower-level, which might require more work to integrate with modern microservices.
3. Write-heavy Workloads: As a strongly consistent system, it can become a bottleneck under heavy write loads, affecting performance.
### Netflix Eureka
Pros:
1. Designed for Microservices: Eureka is designed specifically for service discovery in microservices architectures, particularly within the context of Netflix’s use cases.
 
2. Ease of Integration: With Spring Cloud Netflix, integrating Eureka with a Spring Boot application is straightforward and requires minimal configuration.
3. Client-Side Load Balancing: Works seamlessly with Spring Cloud Ribbon for client-side load balancing.
4. Resilient by Design: Offers resilience patterns built into the client library, allowing fallbacks and retries.
Cons:
1. Consistency: Eureka is designed with eventual consistency in mind, which might not be suitable for all use cases where strong consistency is needed.
2. Single Purpose: While Eureka excels at service registration and discovery, it is not intended for use as a general distributed coordination service like ZooKeeper.
3. End of Open Maintenance: Netflix has retired its use of Eureka internally and has moved the project to maintenance mode, which means fewer updates and potential stagnation of the project.
### Decision Criteria
- Use Case: If you need a general-purpose distributed coordination service that can also handle service registration, ZooKeeper may be a better choice. However, if your primary need is service discovery in a microservices architecture, Eureka might be more appropriate.
- Operational Complexity: Consider the expertise of your team and the operational overhead you're willing to manage. ZooK
eeper can be more complex to set up and maintain, especially in large deployments.
- Consistency vs. Availability: If your system requires strong consistency, ZooKeeper is preferable. For systems that can tolerate eventual consistency, Eureka is suitable.
- Ecosystem and Integration: If you're using Spring Boot or the Spring Cloud ecosystem heavily, Eureka can offer better integration and quicker setup.
In summary, choose ZooKeeper for robust coordination and broader use cases beyond microservices. Opt for Eureka if your focus is purely on microservices service discovery and you're working within a Spring ecosystem. Evaluate your specific requirements and constraints to make the best decision.


