
https://www.azul.com/presentation/azul-webinar-open-source-flight-recorder-and-mission-control-managing-and-measuring-openjdk-8-performance/
https://docs.oracle.com/javase/8/docs/technotes/guides/troubleshoot/tooldescr004.html


How to produce a flight recording.
- Use Java Mission Control to Produce a Flight Recording
- Use Startup Flags at the Command Line to Produce a Flight Recording
- Use Triggers for Automatic Recordings


/////////////////////////////////////////////////
		JVM startup flags
/////////////////////////////////////////////////
-XX:-FlightRecorder 	turns off flight recorder
-XX:-FlightRecorderOptions=option1=value1,option2=value2
-XX:-StartFlightRecording=option1=value1,option2=value2

1. Start a profiling recording: You can configure a time fixed recording at the start of the application using the *-XX:StartFlightRecording*option. Because the JFR is a commercial feature, you must specify the *-XX:+UnlockCommercialFeatures* option. The following example illustrates how to run the *MyApp* application and start a 60-second recording 20 seconds after starting the JVM, which will be saved to a file named *myrecording.jfr*: 
`java -XX:+UnlockCommercialFeatures -XX:+FlightRecorder -XX:StartFlightRecording=delay=20s,duration=60s,name=myrecording,filename=C:\TEMP\myrecording.jfr,settings=profile MyApp`
The settings parameter takes either the path to or the name of a template. Default templates are located in the *jre/lib/jfr* folder. The two standard profiles are: *default* - a low overhead setting made primarily for continuous recordings and *profile* - gathers more data and is primarily for profiling recordings.
2.	Start a continuous recording: You can also start a continuous recording from the command line using *-XX:FlightRecorderOptions*. These flags will start a continuous recording that can later be dumped if needed. The following example illustrates a continuous recording. The temporary data will be saved to disk, to the */tmp* folder, and 6 hours of data will be stored.
 `java -XX:+UnlockCommercialFeatures -XX:+FlightRecorder -XX:FlightRecorderOptions=defaultrecording=true,disk=true,repository=/tmp,maxage=6h,settings=default MyApp` 
 Note: When you actually dump the recording, you specify a new location for the dumped file, so the files in the repository are only temporary.


/////////////////////////////////////////////////
		JCMD 
/////////////////////////////////////////////////
Use jcmd to control FR on running JVM
FYI: main class name may be used instead of pid.

```
jcmd <pid> JFR.start
jcmd <pid> JFR.start defaultrecording=true
jcmd <pid> JFR.dump name=1 filename=/tmp/load.jfr
jcmd <pid> JFR.stop
```


/////////////////////////////////////////////////
		Default Recording config
/////////////////////////////////////////////////
Default Event recording configurations are located in $JAVA_HOME/jre/lib/jfr (JDK 8)  or $JAVA_HOME/lib/jfr  (JDK 11)

- default.jfc  	a low overhead setting made primarily for continuous recordings
- profile.jfc	gathers more data and is primarily for profiling recordings









