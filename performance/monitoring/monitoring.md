
?:P_;o9]# мониторинг
http://www.ibm.com/developerworks/ru/library/j-rtm1/index.html
http://www.ibm.com/developerworks/ru/library/j-rtm2/index.html
http://www.ibm.com/developerworks/ru/library/l-jvmbytecode_mdf_1/


http://www.ibm.com/developerworks/ru/library/j-5things7/index.html - 
Пять секретов... контроля производительности Java

http://www.ibm.com/developerworks/ru/library/j-java6perfmon/index.html - 
Мониторинг и диагностика производительности в Java SE 6

http://www.ibm.com/developerworks/ru/library/j-mxbeans/index.html - 
Использование компонентов управления платформой Java

http://habrahabr.ru/post/143468/  -
Елизаров Do It Yourself Java Profiling

javac. Пакет javax.annotation.processing 
http://habrahabr.ru/post/88908/ - 
Подсчёт времени выполнения метода через аннотацию

JVMTM Tool Interface 
http://docs.oracle.com/javase/6/docs/platform/jvmti/jvmti.html#Allocate

Пакет javax.interceptor 
http://spec-zone.ru/RU/Java/EE/6.0.1/docs/api/javax/interceptor/package-summary.html


https://www.youtube.com/watch?v=UzM4S1hXNtU&feature=youtu.be -
Алексей Рагозин - Диагностические интерфейсы JVM, или Как сделать профайлер своими руками

## Ключевые метрики
Отслеживаемые в стандартных инструментальных панелях метрики включают общую информацию о сервере, устройстве, Java машине, операционной системе и ее версии, времени работы приложения, использованию памяти, а также:
	•	Heap Memory (Init Size, Used, Committed, Max Size) 
	•	Non Heap Memory (Init Size, Used, Committed, Max Size) 
	•	Classes( Loaded Count, Total Loaded Count, Unloaded Count) 
	•	Garbage Collections (Count, Mark Sweep Collection Time, Scawenge Collection Time, Total Collection Time) 
	•	Memory Pools (Init Size, Used, Committed, Max Size)Memory Pool Committed 
	•	Threads (Total Started Count, Leave, Daemon, Peak) 
	•	И другие 
Доступно через java.lang.management - MXBeans для мониторинга JVM




Коннекции (количество, переданные / полученные данные)
Транзакции
SQL запросы
RMI-запросы (response time)
error rate
вызов конкретного метода (кол-во, время исполнения)

## инструментирование …
http://commons.apache.org/proper/commons-bcel/manual.html#a2_The_Java_Virtual_Machine — bcel

http://www.java2s.com/Product/Java/Byte-Source-Code/Byte-Code-Edit.htm
список библиотек


