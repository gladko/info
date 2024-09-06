    Best practices for performance troubleshooting:
Based on https://docs.oracle.com/javase/8/docs/technotes/guides/troubleshoot


Enable JVM monitoring:
- Print Java version and JVM flags: have the basic information handy in the log files. For example, it's helpful to print out the Java version and the JVM flags used. If your application starts with a script, simply run `java -version` to print the Java version and print the command line before executing it. Another alternative is to add *-XX+PrintCommandLineFlags* and *-showversion* to the JVM arguments.
- Enable core files.  If Java crashes, for example due to a segmentation fault, the OS saves to disk a *core file* (complete dump of the memory)
- Add *-XX:+HeapDumpOnOutOfMemoryError* to the JVM flags: The *-XX:+HeapDumpOnOutOfMemoryError* flag saves a Java Heap dump to disk if the applications runs into an OutOfMemoryError.
- Add *-verbosegc* to the JVM command-line: The flag *-verbosegc* logs basic information about Java Garbage Collector.
- Set up JMC JMX for remote monitoring
- Run a continuous Java flight recording



If the application has stopped responding, then gather the following files.
- Stack traces: Take several stack traces using `jcmd <pid> Thread.print` before restarting the system. (Or `jstack <pid>` )
- Dump flight recordings (if enabled).
- Force a core file: If the application can't be closed properly, then stop the application and force a core file using *kill -6 <pid>* on Linux or Solaris systems.
