http://nkoksharov.blogspot.ru/2008/11/javaagent.html

## Кто такой javaagent? 
У Java-машины есть один интересный параметр -javaagent. О нем почему-то весьма мало сказано в документации по самой JVM, есть лишь описание в javadoc java.lang.instrument. Сам параметр появился начиная с Java 1.5, и позволяет получать доступ к механизму манипулирования с байт-кодом классов (трансформация, переопределение классов).
В командной строке он выглядит так:
    `-javaagent:jarpath[=options]`
где jarpath - путь к jar-нику содержащему класс agent-а, и options - строка доп. параметров agent-а, передается при его вызове.
Сам параметер может содержаться несколько раз в строке параметров JVM, позволяя загружать несколько agent-ов. Указываемый JAR должен удовлетворять спецификации JAR-файла, т.е. иметь манифест файл META-INF/MANIFEST.MF, со следующими возможными атрибутами:
	•	Premain-Class (обязательный) - он содержит имя класса agent-а с premain методом.
	•	Boot-Class-Path - содержит как абсолютные так и относительные пути поиска классов, для Bootstrap classloader-а. Относительный путь начинается от абсолютного пути самого JAR-файла. Пути могут указывать как на директорию, так и на jar-библиотеку. В качестве разделителя используются пробел. Эти пути будут использоваться в случае, если какие-то классы не были найдены стандартными механизмами Java.
	•	Can-Redefine-Classes - указывает возможность переопределения классов, может иметь значение true, либо false (по-умолчанию).
	•	Can-Retransform-Classes (только в Java 1.6) - указывает возможность ретрансформации классов, может иметь значение true, либо false (по-умолчанию).
Метод premain, может иметь одну из следующих сигнатур:
public static void premain(String agentArgs, Instrumentation inst);
public static void premain(String agentArgs); (только Java 1.6)
В agentArgs передается сама строка options, разработчик должен сам реализовать логику парсинга этой строки, если хочет передавать в ней несколько аргументов. Собственно сам интерфейс java.lang.instrument.Instrumentation и предоставляет нам доступ к механизмам операций с байт-кодом. Сам метод premain вызывается, как вы уже должно быть поняли, еще до выполнения метода main приложения. 
```
public class InstrumentExample {
    private static Instrumentation inst;
    public static void premain(String options, Instrumentation inst) {
        inst.addTransformer(new SomeTransformer());
        this.inst = inst;
    }
    public static void main(String args[] ) {
     
        ...
        byte[] classBytes = ...
        ClassDefinition classDef = new ClassDefinition(SomeClass.class, classBytes);
        inst.redefineClasses(classDef);
        ...
        
    }
    public static class SomeTransformer implements ClassFileTransformer {
        public byte[] transform(java.lang.ClassLoader loader,
                java.lang.String className,
                java.lang.Class classBeingRedefined,
                java.security.ProtectionDomain protectionDomain,
                byte[] classfileBuffer) throws IllegalClassFormatException
        {
            ...
        }
    }
    ...
}
```
Чтобы использовать механизм трансфорамации классов вам нужно реализовать интерфейс java.lang.instrument.ClassFileTransformer. И зарегистрировать свою реализацию через метод Instrumentation.addTransformer. Сам трасформер будет срабатывать каждый раз при:
	•	загрузке класса ClassLoader.defineClass
	•	переопределении класса Instrumentation.redefineClasses 
	•	ретрансформации класса Instrumentation.retransformClasses.
Аргумент classfileBuffer содержит байт-код текущей версии класса, и его нельзя модифицировать, для его переопределения трансформер должен вернуть новый массив байт, либо null, если трансформация не была произведена. В случае, когда трансформеров несколько, то они будут вызваны по цепочке, при этом classfileBuffer будет результатом предыдущего трансформера. Чтобы сообщить об ошибке при трансформации необходимо выбросить java.lang.instrument.IllegalClassFormatException, при unchecked-ошибках результат будет такой, как если бы метод вернул null.
Для переопределения класса необходимо указать выше описанный параметер в манифесте и использовать класс java.lang.instrument.ClassDefinition. Только вот есть ограничения: переопределение класса не должно добавлять, удалять новые поля или методы, менять сигнатуру методов или иерархию наследования. Можно менять только тело методов, структура класса меняться не должна. Если в приложении уже используются экземпляры предыдущей версии класса, то с ними ничего не произойдет, однако при последующем создании класса, будет использована уже новая версия.
К сожалению, Java-платформа не предоставляет стандартных инструментов для модификации/генерации байт-кода. В этом случае можно воспользоваться уже готовыми фреймворками, например, Javaassist или BCEL.
Javaаgent реализован в фреймворке Spring, чтобы можно было использовать AOP для классов, вне контекста. Тестовый фреймворк Jmockit также реализует своего javaagent-а. Тем самым открывая возможность писать mock-и для классов, экземпляры которых вы не можете заменить обычными способами, либо они содержат статические методы, заменить которые возможно только до загрузки класса.



[Asm](http://asm.ow2.org/doc/tutorial-asm-2.0.html)
