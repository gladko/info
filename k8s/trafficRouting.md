[Load balancing and scaling long-lived connections in Kubernetes](https://learnk8s.io/kubernetes-long-lived-connections)

TL;DR: Kubernetes doesn't load balance long-lived connections, and some Pods might receive more requests than others. Consider client-side load balancing or a proxy if you're using HTTP/2, gRPC, RSockets, AMQP, or any other long-lived database connection.