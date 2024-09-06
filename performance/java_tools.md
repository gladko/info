	https://docs.oracle.com/javase/8/docs/technotes/guides/troubleshoot/tooldescr001.html#BABCBIDC

## Simple tools
 - *jcmd*	- Prints basic class, thread, and JVM information for a Java process.
 - *jmap*	- Provides heap dumps and other information about JVM memory usage. Suitable for scripting, though the heap dumps must be used in a postprocessing tool.
 - *jinfo*	- Provides visibility into the system properties of the JVM, and allows some system properties to be set dynamically. Suitable for scripting.
 - *jstack*	- Dumps the stacks of a Java process. Suitable for scripting.
 - *jstat*	- Provides information about GC and class-loading activities. Suitable for scripting.
 - *jps*	- Shows running JVM



## Reach tools
 - *jconsole* 	Provides a graphical view of JVM activities, including thread usage, class usage, and GC activities

 - *jvisualvm*	A GUI tool to monitor a JVM, profile a running application, and analyze JVM heap dumps (which is a postprocessing activity, though jvisualvm can also take the heap dump from a live program).

 - *Java Mission Control*

 - *visualgc*	- provides a graphical view of the garbage collection system. As with jstat, it uses the built-in instrumentation of Java HotSpot VM
 



##	jcmd usages examples

`jcmd <pid> help ManagementAgent.start`		shows JMX flags that can be sent with the command
`jcmd <pid> Thread.print`					thread dumps
`jcdm <pid> PerfCounter.print`				shows jvm perf counters


The following commands are available (java 11):
 - Compiler.CodeHeap_Analytics
 - Compiler.codecache
 - Compiler.codelist
 - Compiler.directives_add
 - Compiler.directives_clear
 - Compiler.directives_print
 - Compiler.directives_remove
 - Compiler.queue
 - GC.class_histogram			- Similar to  `jmap -histo`
 - GC.class_stats				- loaded classes stat
 - GC.finalizer_info
 - GC.heap_dump					- Similar to  `jmap -dump:file=<file> <pid>`, but *jcmd* is the recommended tool to use.
 - GC.heap_info
 - GC.run
 - GC.run_finalization
 - JFR.check
 - JFR.configure
 - JFR.dump
 - JFR.start
 - JFR.stop
 - JVMTI.agent_load
 - JVMTI.data_dump
 - ManagementAgent.start  		- JMX
 - ManagementAgent.start_local
 - ManagementAgent.status
 - ManagementAgent.stop
 - Thread.prints				- similar to `jstack`
 - VM.class_hierarchy			- class inheritance hierarchy
 - VM.classloader_stats
 - VM.classloaders
 - VM.command_line
 - VM.dynlibs					- Dynamic libraries
 - VM.flags
 - VM.info 						- similar to JVM post mortem report
 - VM.log
 - VM.metaspace
 - VM.native_memory				- get memory report (-XX:NativeMemoryTracking has to be on)
 - VM.print_touched_methods
 - VM.set_flag
 - VM.stringtable
 - VM.symboltable
 - VM.system_properties			- !
 - VM.systemdictionary
 - VM.uptime
 - VM.version
 - help


PS: there are lot of another commands in further java versions



```
 $ jcmd 21871 GC.heap_info
21871:
 garbage-first heap   total 99328K, used 27906K [0x0000000700000000, 0x0000000800000000)
  region size 1024K, 1 young (1024K), 0 survivors (0K)
 Metaspace       used 51971K, capacity 55368K, committed 57088K, reserved 1097728K
  class space    used 6640K, capacity 8028K, committed 8548K, reserved 1048576K
 ```


 ```
 $ jcmd 21871 VM.command_line
21871:
VM Arguments:
jvm_args: --add-opens=java.desktop/javax.swing.plaf.basic=ALL-UNNAMED --add-opens=java.base/java.io=ALL-UNNAMED --add-opens=java.base/java.net=ALL-UNNAMED --add-opens=java.transaction.xa/javax.transaction.xa=ALL-UNNAMED --add-opens=java.management/javax.management=ALL-UNNAMED --add-opens=java.rmi/java.rmi=ALL-UNNAMED --add-opens=java.security.jgss/org.ietf.jgss=ALL-UNNAMED --add-opens=java.sql/java.sql=ALL-UNNAMED --add-opens=java.base/sun.net.www.protocol.http=ALL-UNNAMED --add-opens=java.base/sun.net.www.protocol.https=ALL-UNNAMED -Djava.library.path=/usr/local/lib
java_command: com.mucommander.main.muCommander
java_class_path (initial): mucommander-1.4.0.jar
Launcher Type: SUN_STANDARD
```

```
 $ jcmd 21871 VM.classloaders
21871:
+-- <bootstrap>
      |
      +-- org.apache.felix.framework.BundleWiringImpl$BundleClassLoader (+ 62 more)
      |
      +-- jdk.internal.reflect.DelegatingClassLoader (+ 14 more)
      |
      +-- "platform", jdk.internal.loader.ClassLoaders$PlatformClassLoader
      |     |
      |     +-- "app", jdk.internal.loader.ClassLoaders$AppClassLoader
      |           |
      |           +-- jdk.internal.reflect.DelegatingClassLoader
      |           |
      |           +-- com.mucommander.commons.file.AbstractFileClassLoader
      |
      +-- org.apache.felix.framework.BundleWiringImpl$BundleClassLoader
      |     |
      |     +-- jdk.internal.reflect.DelegatingClassLoader
      |
      +-- org.apache.felix.framework.BundleWiringImpl$BundleClassLoader
            |
            +-- jdk.internal.reflect.DelegatingClassLoader

```


```
$  jcmd 21871 VM.flags
21871:
-XX:CICompilerCount=4 -XX:ConcGCThreads=3 -XX:G1ConcRefinementThreads=10 -XX:G1HeapRegionSize=1048576 -XX:GCDrainStackTargetSize=64 -XX:InitialHeapSize=268435456 -XX:MarkStackSize=4194304 -XX:MaxHeapSize=4294967296 -XX:MaxNewSize=2576351232 -XX:MinHeapDeltaBytes=1048576 -XX:NonNMethodCodeHeapSize=5836300 -XX:NonProfiledCodeHeapSize=122910970 -XX:ProfiledCodeHeapSize=122910970 -XX:ReservedCodeCacheSize=251658240 -XX:+SegmentedCodeCache -XX:+UseCompressedClassPointers -XX:+UseCompressedOops -XX:+UseG1GC
```


