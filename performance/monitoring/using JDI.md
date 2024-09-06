# Используем JDI 


## JPDA—платформа
Сегодня мы расскажем, что собой представляет JPDA—платформа отладки Java и более подробно остановимся на одной из её составляющих — интерфейсе JDI.
Для платформы Java спецификация JPDA определяет несколько уровней стандартных интерефйсов, которые делают возможными мониторинг, профилирование и отладку программ.

JPDA состоит из трёх основных интерфейсов:
  -	**JVMTI** - описывает набор сервисов, которые предоставляет ВМ для мониторинга и отладки. Для использования JVMTI необходимо написать агента на C/C++ (или другом языке, который поддерживает соглашение о вызовах C/C++). JVMTI-агент запускается в одном процессе с ВМ и взаимодействует с ней через native интерфейс (подробнее см. спецификацию JVMTI). Минусом использования JVMTI для написания приложений можно считать необходимость использования интерфейса native, что делает приложение зависящим от платформы.
  -	**JDWP** — это протокол обмена информацией между отладчиком и отлаживаемой ВМ (точнее между отладчиком и агентом, запущенным в отлаживаемой ВМ и поддерживающим JDWP). JDWP определяет формат запросов отладчика и формат ответа отлаживаемого процесса на эти запросы. Надо отметить, что JDWP не определяет ни механизм обмена информацией (пакеты могут передаваться как через TCP/IP соединение, так и любым другим способом) ни то, где должны находиться отладчик и отлаживаемая ВМ: на одной или разных машинах. JDWP близок по возможностям к JVMTI, но предоставляет дополнительные функции, например, фильтрование событий (подробнее—в описании JDWP).
  -	**JDI** — это 100% Java-интерфейс более высокого уровня, чем JVMTI и JDWP, и именно он предназначен и наиболее удобен для написания приложений.

Реализация JDI доступна вместе с JDK начиная с версии 1.3 и, конечно же, от версии к версии предоставляет всё больше возможностей. Классы, реализующие JDI, находятся в jar-файле *{JDK}/lib/tools.jar*. Также JDK включает несколько интересных примеров программ использующих JDI: *{JDK}/demo/jpda/examples.jar*. При компиляции и запуске примеров путь к классам должен включать tools.jar.

## Пишем JDI приложение
Чтобы разобраться в некоторых деталях использования JDI, напишем простое приложение, использующее этот интерфейс.
Прежде чем начать работать с отлаживаемой программой отладчик должен установить с ней соединение. Есть несколько способов сделать это. JDI определяет абстракцию, называемую *коннектор (Connector)*, которая инкапсулирует процесс установки соединения между отладчиком (написанным с использованием JDI) и отлаживаемой виртуальной машиной. Различные реализации JDI могут поддерживать работу со специфичными виртуальными машинами, например, с виртуальными машинами, для встраиваемых (embedded) устройств. В таких случаях может понадобиться реализовать специальный коннектор.

Коннекторы делятся на 3 типа:
 -	запускающий коннектор (Launching connector): отладчик сам запускает отлаживаемый процесс
 -	слушающий коннектор (Listening connector): отладчик ждёт входящее соединение со стороны отлаживаемой ВМ
 -	присоединяющийся коннектор (Attaching connector): отладчик присоединяется к уже запущенной ВМ

Другая абстракция, используемая в JPDA — это транспорт (Transport). Транспорт это способ передачи данных между отладчиком и отлаживаемой ВМ. В ВМ компании Sun доступны 2 вида транспортов: 
 -	использующий сокеты. Он устанавливает TCP/IP соединение между отладчиком и отлаживаемой ВМ. 
 -	использующий для обмена JDWP пакетами разделяемую память (shared memory). Этот тип транспорта доступен только для Windows. 

Разработчику не надо напрямую работать с транспортами. Необходимый транспорт на стороне отладчика создает коннектор, а на стороне отлаживаемой ВМ — агент, поддерживающий JDWP.

Рассмотрим пример использования коннектора, доступного в ВМ компании Sun (в приведённых примерах используются сокращённые имена классов без указания имён пакетов. Все используемые классы расположены в следующих пакетах: *com.sun.jdi*, *com.sun.jdi.connect*, *com.sun.jdi.event*, *com.sun.jdi.request*).

Сначала необходимо получить объект VirtualMachineManager, это делается с помощью класса Bootstrap, который содержит всего один метод:
`VirtualMachineManager virtualMachineManager = Bootstrap.virtualMachineManager()`

Списки доступных коннекторов можно получить, используя следующие методы VirtualMachineManager: attachingConnectors(), listeningConnectors(), launchingConnectors().

Один из доступных запускающих коннекторов — com.sun.jdi.CommandLineLaunch, этот коннектор требует только один обязательный параметр — имя главного класса отлаживаемого приложения:
```
        // получаем список всех запускающих коннекторов
        for (LaunchingConnector launchingConnector : virtualMachineManager.launchingConnectors()) {
            // ищем коннектор с заданным именем
            if (launchingConnector.name().equals("com.sun.jdi.CommandLineLaunch")) {
                // получаем список аргументов коннектора по умолчанию
                Map arguments = launchingConnector.defaultArguments();
            
                // получаем аргумент 'main' - имя главного класса отлаживаемого приложения    
                Argument argument = (Connector.StringArgument)arguments.get("main");
                argument.setValue("ApplicationMainClass"); 
                
                try {
                    // запускаем отлаживаемое приложение и получаем объект VirtualMachine
                    VirtualMachine vm = launchingConnector.launch(arguments);
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }
```

Также доступны более специфичные коннекторы: например, есть коннекторы, позволяющие работать с core-файлами (*sun.jvm.hotspot.jdi.SACoreAttachingConnector*) или с процессами, которые были запущены без каких-либо специальных опций, таких как *-agentlib:jdwp (sun.jvm.hotspot.jdi.SAPIDAttachingConnector*).

После того как получен объект VirtualMachine, у отладчика появляется доступ к различной информации об отлаживаемой ВМ и есть возможность влиять на её состояние. JDI может использоваться для создания всевозможных программ для контроля состояния ВМ. Например, новые возможности появившеся в JDK6 позволяют получать информацию о всех объектах, находящихся в heap-памяти отлаживаемой ВМ (heap walking). Один из вариантов использования этой возможности — создание средств для обнаружения утечек памяти.
Также отладчик может получать уведомления о событиях, происходящих в отлаживаемой ВМ, таких как, например, загрузка класса, запуск потока, вызов метода, чтобы получать события необходимо создать запрос с помощью класса EventRequestManager:
```
    ClassPrepareRequest request = virtualMachine.eventRequestManager().createClassPrepareRequest();
    request.enable();
 ```

С помощью метода *EventRequest.setSuspendPolicy(int policy)* для запроса можно задать режим временной остановки (suspend policy), где policy может принимать одно из следующих значений:
 - EventRequest.SUSPEND_ALL — приостановить все потоки при наступлении события
 - EventRequest.SUSPEND_EVENT_THREAD — приостановить только поток, в котором произошло событие
 - EventRequest.SUSPEND_NONE — не приостанавливать ни один поток при наступлении события

После того как запрос создан можно запросить полученные события из очереди события: `EventSet eventSet = virtualMachine.eventQueue().remove()`

Так как метод *EventQueue.remove()* блокирует вызывающий поток пока не получено событие, для получения событий как правило запускается отдельный поток, который постоянно опрашивает очередь.

Рассмотрим еще пример приложения, использующего JDI. Следующая программа отслеживает в отлаживаемой программе загружаемые классы с помощью обработки событий типа ClassPrepareEvent:
```
// JDIExample.java
import java.util.\*;
import com.sun.jdi.\*;
import com.sun.jdi.connect.\*;
import com.sun.jdi.connect.Connector.Argument;
import com.sun.jdi.event.\*;
import com.sun.jdi.request.\*;
// отлаживаемое приложение
class TargetApplication {
    public static void main(String args[]) {
        System.out.println("Привет, мир!");
    }
}
// интерфейс слушателя событий
interface EventListener {
    // получено событие VMStartEvent
    public void vmStartEvent(VMStartEvent event);
    // получено событие ClassPrepareEvent
    public void classPrepareEvent(ClassPrepareEvent event);
}
public class JDIExample implements EventListener {
    // поток опрашивает очередь событий и передаёт полученные события слушателю
    // (EventListener) до тех пор, пока не получено событие VMDisconnectEvent
    public class EventListenerThread extends Thread {
        private EventListener eventListener;
        public EventListenerThread(EventListener eventListener) {
            this.eventListener = eventListener;
        }
        public void run() {
            try {
                while (true) {
                    EventQueue eventQueue = virtualMachine.eventQueue();
                    EventSet eventSet = eventQueue.remove();
                    EventIterator eventIterator = eventSet.eventIterator();
                    while (eventIterator.hasNext()) {
                        Event event = eventIterator.nextEvent();
                        if (event instanceof VMDisconnectEvent) {
                            // получаем это событие когда потеряно соединение с ВМ 
                            // (ВМ завершила работу) 
                            System.out.println("потеряно соединение с ВМ");
                            return;
                        } else if (event instanceof VMStartEvent) {
                            eventListener.vmStartEventCallback((VMStartEvent) event);
                        } else if (event instanceof ClassPrepareEvent) {
                            eventListener.classPrepareEventCallback((ClassPrepareEvent) event);
                        }
                    }
                }
            } catch (Exception e) {
                // для простоты игнорируем все исключительные ситуации
                e.printStackTrace();
            }
        }
    }
    public void vmStartEventCallback(VMStartEvent event) {
        System.out.println("ВМ запущена");
        // создаём запрос для получения событий ClassPrepareEvent
        ClassPrepareRequest request = 
                virtualMachine.eventRequestManager().createClassPrepareRequest();
        // не приостанавливать ВМ при наступлении событий
        request.setSuspendPolicy(EventRequest.SUSPEND_NONE);
        request.enable();
        // по умолчанию политика приостановки для события VMStartEvent--
        // SUSPEND_ALL, поэтому после получения этого события надо вызвать
        // VirtualMachine.resume()
        virtualMachine.resume();
    }
    public void classPrepareEventCallback(ClassPrepareEvent event) {
        System.out.println("Класс '" + event.referenceType().name() + "' был подготовлен");
    }
    VirtualMachine virtualMachine;
    // запустить ВМ
    VirtualMachine startTargetVM(String mainClassName) {
        
        VirtualMachineManager virtualMachineManager = Bootstrap.virtualMachineManager();
        LaunchingConnector connector = virtualMachineManager.defaultConnector();
        Map arguments = connector.defaultArguments();
        Argument arg = (Connector.StringArgument) arguments.get("main");
        // указываем главный класс отлаживаемого приложения
        arg.setValue(mainClassName);
        try {
            VirtualMachine vm = connector.launch(arguments);
            return vm;
        } catch (Exception e) {
            System.out.println("Ошибка при запуске ВМ: " + e);
            e.printStackTrace();
        }
        return null;
    }
    public void execute() {
        virtualMachine = startTargetVM("TargetApplication");
        if (virtualMachine == null)
            return;
        EventListenerThread listenerThread = new EventListenerThread(this);
        listenerThread.start();
        try {
            listenerThread.join();
        } catch (InterruptedException e) {
        }
    }
    public static void main(String args[]) {
        new JDIExample().execute();
    }
}
```

При компиляции и запуске не забываем указать расположение tools.jar и затем смотрим, сколько классов надо загрузить для выполнения приложения "Привет, мир!":
```
% /usr/java/jdk1.6.0/bin/javac -classpath /usr/java/jdk1.6.0/lib/tools.jar JDIExample.java
% /usr/java/jdk1.6.0/bin/java -classpath .:/usr/java/jdk1.6.0/lib/tools.jar JDIExample
ВМ запущена
Класс 'java.lang.ClassNotFoundException' был подготовлен
Класс 'java.net.URLClassLoader$1' был подготовлен
Класс 'sun.misc.URLClassPath$3' был подготовлен
Класс 'sun.misc.URLClassPath$Loader' был подготовлен
Класс 'sun.misc.URLClassPath$JarLoader' был подготовлен
Класс 'java.lang.StringBuffer' был подготовлен
Класс 'java.lang.Short' был подготовлен
Класс 'java.security.PrivilegedActionException' был подготовлен
Класс 'sun.misc.URLClassPath$FileLoader' был подготовлен
Класс 'sun.misc.Resource' был подготовлен
Класс 'sun.misc.URLClassPath$FileLoader$1' был подготовлен
Класс 'java.security.CodeSource' был подготовлен
Класс 'java.security.PermissionCollection' был подготовлен
Класс 'java.security.Permissions' был подготовлен
Класс 'java.net.URLConnection' был подготовлен
Класс 'sun.net.www.URLConnection' был подготовлен
Класс 'sun.net.www.protocol.file.FileURLConnection' был подготовлен
Класс 'java.net.ContentHandler' был подготовлен
Класс 'java.net.UnknownContentHandler' был подготовлен
Класс 'sun.net.www.MessageHeader' был подготовлен
Класс 'java.io.FilePermission' был подготовлен
Класс 'java.io.FilePermission$1' был подготовлен
Класс 'java.security.Policy' был подготовлен
Класс 'sun.security.provider.PolicyFile' был подготовлен
Класс 'java.security.Policy$UnsupportedEmptyCollection' был подготовлен
Класс 'java.io.FilePermissionCollection' был подготовлен
Класс 'java.security.BasicPermissionCollection' был подготовлен
Класс 'java.security.ProtectionDomain' был подготовлен
Класс 'TargetApplication' был подготовлен
Класс 'sun.nio.cs.Surrogate' был подготовлен
Класс 'java.util.AbstractList$Itr' был подготовлен
Класс 'java.util.IdentityHashMap$KeySet' был подготовлен
Класс 'java.util.IdentityHashMap$IdentityHashMapIterator' был подготовлен
Класс 'java.util.IdentityHashMap$KeyIterator' был подготовлен
Класс 'java.io.DeleteOnExitHook' был подготовлен
Класс 'java.util.LinkedHashSet' был подготовлен
Класс 'java.util.HashMap$KeySet' был подготовлен
Класс 'java.util.LinkedHashMap$LinkedHashIterator' был подготовлен
Класс 'java.util.LinkedHashMap$KeyIterator' был подготовлен
потеряно соединение с ВМ
```

Приведённый пример очень простой из-за ограничений на размер, накладываемых рамками поста. На самом деле, возможности приложения, использующего JDI, ограничены только вашей фантазией. Удачи!
Семён Бойков

