
- Shallow size - непосредственный размер объекта без учета размера зависимых объектов
- Deep size -  полный размер объекта
- Retain size - количество памяти, которое будет освобождено, если этот объект умрет



##	NativeMemoryTracking

https://docs.oracle.com/javase/8/docs/technotes/guides/troubleshoot/tooldescr007.html

java -XX:NativeMemoryTracking=[summary|detail]
	5-10% overhead
	+2 words/malloc
	allocation only inside JVM

jcmd PID VM.native_memory [detail]   - get memory report (NativeMemoryTracking has to be on)




##	Eclipce memory analyzer (MAT)

https://wiki.eclipse.org/MemoryAnalyzer/FAQ


Requires lot of memory for opening big memory dumps. In general, it requires as much memory as the size of dump.
Workaround: execute indexing & report generation remotely on a host where is enough memory.



##	Programmatical memory analyze

[OQL wiki](https://wiki.eclipse.org/MemoryAnalyzer/OQL)

http://blog.ragozin.info/2015/02/programatic-heapdump-analysis.html
https://github.com/aragozin/heaplib/tree/master/hprof-heap



[MAT/Calcite](https://github.com/vlsi/mat-calcite-plugin)     MAT plugin for execution SQL-like queries




https://wiki.eclipse.org/MemoryAnalyzer/OQL.      		MemoryAnalyzer/FAQ

https://stackoverflow.com/questions/7254017/tool-for-analyzing-large-java-heap-dumps			Run MAT from CLI


https://help.eclipse.org/latest/index.jsp?topic=%2Forg.eclipse.mat.ui.help%2Ftasks%2Fqueryingheapobjects.html.     			Querying Heap Objects (OQL)


https://help.eclipse.org/latest/index.jsp?topic=%2Forg.eclipse.mat.ui.help%2Freference%2Foqlsyntax.html    			SELECT Clause


http://cr.openjdk.java.net/~sundar/8022483/webrev.01/raw_files/new/src/share/classes/com/sun/tools/hat/resources/oqlhelp.html     	Object Query Language (OQL)

https://xy2401.com/local-doc-help.eclipse.org-neon/org.eclipse.mat.ui.help/tasks/queryingheapobjects.html.  					Querying Heap Objects (OQL)

https://github.com/aragozin/heaplib				HeapLib. 

https://jvmperf.net/docs/memory/mat/.   			 Eclipse MAT





```
SELECT i FROM OBJECTS ( SELECT OBJECTS arr.@referenceArray FROM OBJECTS 20866817 arr ) i WHERE i.instrumentProperties.symbol.toString().equals(“FSV”)

SELECT OBJECTS elem.<field_name> FROM OBJECTS (SELECT OBJECTS arr.@referenceArray FROM OBJECTS <your_array_address> arr) elem

SELECT elem.key.toString() FROM OBJECTS ( SELECT OBJECTS arr.@referenceArray FROM OBJECTS 328186 arr  ) elem WHERE elem.key.toString().equals("IBM")
```




| item | MAT/Calcite query | result |
|-|-|-|
| size of ResponseTO | select sum (retainedSize(x.this)) retained_size from "instanceof.com.foo.bar.Person" x | 460,500,568 |
| size of RequestTO  | select sum (retainedSize(x.this)) retained_size from "instanceof.com.foo.bar.Employee" x | 13,383,944 |
| Account            | select sum (retainedSize(x.this)) from "instanceof.com.foo.bar.Account" x | 1,851,013,936 |


