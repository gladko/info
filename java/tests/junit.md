# Mock
http://apofig.blogspot.ru/2011/11/mockito.html      Java for fun: Как работать с Mockito?
http://code.google.com/p/mockito/                   MOCKITO_HOME
http://habrahabr.ru/post/136466/                    JMock и EasyMock: сравнение и howto
  

Тест-дублеры:
 - *Dummy* – пустые объекты, которые передаются в вызываемые внутренние методы, но не используются. Предназначены лишь для заполнения параметров методов. 
 - *Fake* – объекты, имеющие работающие реализации, но в таком виде, который делает их неподходящими для production-кода (например, In Memory Database). 
 - *Stub* – объекты, которые предоставляют заранее заготовленные ответы на вызовы во время выполнения теста и обычно не отвечающие ни на какие другие вызовы, которые не требуются в тесте. Также могут запоминать какую-то дополнительную информацию о количестве вызовов, параметрах и возвращать их потом тесту для проверки. 
 - *Mock* – объекты, которые заменяют реальный объект в условиях теста и позволяют проверять вызовы своих членов как часть системы или unit-теста. Содержат заранее запрограммированные ожидания вызовов, которые они ожидают получить. Применяются в основном для т.н. interaction (behavioral) testing.



## TeamCity
http://confluence.jetbrains.com/display/TCD65/Configuring+Build+Parameters
https://samarthrastogi.wordpress.com/tag/teamcity-junit/
http://samarthrastogi.wordpress.com/2012/02/27/configure-teamcity-in-10-minutes/


## JUNIT
https://github.com/junit-team/junit/wiki    -	 спецификация
http://habrahabr.ru/post/120101/
http://ant.apache.org/manual/Tasks/junit.html    - 	ант таска

## Рулы:
Например, есть встроенные правила для задания таймаута для теста (Timeout), для задания ожидаемых исключений (ExpectedException), для работы с временными файлами (TemporaryFolder) и д.р. Для объявления правила необходимо создать public не static поле типа производного от MethodRule и зааннотировать его с помощью @Rule.

```
@Rule
public final TemporaryFolder folder = new TemporaryFolder();

@Rule
public final Timeout timeout = new Timeout(1000);

@Rule
public final ExpectedException thrown = ExpectedException.none();```
```

## Запускалки:
Как запускается тест, тоже может быть сконфигурировано с помощью @RunWith. При этом класс, указанный в аннотации должен наследоваться от Runner. Рассмотрим запускалки, идущие в комплекте с самим фреймворком.

JUnit4 — запускалка по умолчанию, как понятно из названия, предназначена для запуска JUnit 4 тестов.

JUnit38ClassRunner предназначен для запуска тестов, написанных с использованием JUnit 3.

SuiteMethod либо AllTests тоже предназначены для запуска JUnit 3 тестов. В отличие от предыдущей запускалки, в эту передается класс со статическим методом suite возвращающим тест(последовательность всех тестов).

Suite — эквивалент предыдущего, только для JUnit 4 тестов. Для настройки запускаемых тестов используется аннотация @SuiteClasses.

```
@Suite.SuiteClasses( { OtherJUnit4Test.class, StringUtilsJUnit4Test.class })
@RunWith(Suite.class)
public class JUnit4TestSuite {
}
```

Enclosed — то же, что и предыдущий вариант, но вместо настройки с помощью аннотации используются все внутренние классы.

Categories — попытка организовать тесты в категории(группы). Для этого тестам задается категория с помощью @Category, затем настраиваются запускаемые категории тестов в сюите. Это может выглядеть так:

```
public class StringUtilsJUnit4CategoriesTest extends Assert {
  //...

  @Category(Unit.class)
  @Test
  public void testIsEmpty() {
    //...
  }

  //...
}

@RunWith(Categories.class)
@Categories.IncludeCategory(Unit.class)
@Suite.SuiteClasses( { OtherJUnit4Test.class, StringUtilsJUnit4CategoriesTest.class })
public class JUnit4TestSuite {
}
```

## Parameterized   -- устарело !
Parameterized — довольно интересная запускалка, позволяет писать параметризированные тесты. Для этого в тест-классе объявляется статический метод возвращающий список данных, которые затем будут использованы в качестве аргументов конструктора класса.
```
@RunWith(Parameterized.class)
public class StringUtilsJUnit4ParameterizedTest extends Assert {
  private final CharSequence testData;
  private final boolean expected;

  public StringUtilsJUnit4ParameterizedTest(final CharSequence testData, final boolean expected) {
    this.testData = testData;
    this.expected = expected;
  }

  @Test
  public void testIsEmpty() {
    final boolean actual = StringUtils.isEmpty(testData);
    assertEquals(expected, actual);
  }

  @Parameterized.Parameters
  public static List<Object[]> isEmptyData() {
    return Arrays.asList(new Object[][] {
      { null, true },
      { "", true },
      { " ", false },
      { "some string", false },
    });
  }
}
```


## ParameterizedTest
```
  enum Implementation {CACHING, REUSED_CACHING, NO_CACHING}

  @ParameterizedTest
  @EnumSource(Implementation.class)
  public void testXXX(Implementation impl) {
    ...
  }
```


Theories — чем-то схожа с предыдущей, но параметризирует тестовый метод, а не конструктор. Данные помечаются с помощью @DataPoints и @DataPoint, тестовый метод — с помощью @Theory. Тест использующий этот функционал будет выглядеть примерно так:
```
@RunWith(Theories.class)
public class StringUtilsJUnit4TheoryTest extends Assert {

  @DataPoints
  public static Object[][] isEmptyData = new Object[][] {
      { "", true },
      { " ", false },
      { "some string", false },
  };

  @DataPoint
  public static Object[] nullData = new Object[] { null, true };

  @Theory
  public void testEmpty(final Object... testData) {
    final boolean actual = StringUtils.isEmpty((CharSequence) testData[0]);
    assertEquals(testData[1], actual);
  }
}
```

Как и в случае с правилами, в сети можно найти и другие варианты использования. Например, здесь рассмотрена та же возможность паралельного запуска теста, но с использованием запускалок.


Runners:
RunNotifier - If you write custom runners, you may need to notify JUnit of your progress running tests
RunListener 

