#!/usr/bin/env sh

#  Copyright 2016 Goldman Sachs.
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing,
#  software distributed under the License is distributed on an
#  "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
#  KIND, either express or implied.  See the License for the
#  specific language governing permissions and limitations
#  under the License.

export XSD2BEAN_HOME=$TRAVIS_BUILD_DIR
export JDK_HOME=$JAVA_HOME
export GENERATE_XSD2BEAN_CONCRETE_CLASSES=true

mkdir -p $XSD2BEAN_HOME/libboot/target/classes

$JDK_HOME/bin/javac -d $XSD2BEAN_HOME/libboot/target/classes $XSD2BEAN_HOME/libboot/src/main/java/org/libboot/Libboot.java
$JDK_HOME/bin/java -cp $XSD2BEAN_HOME/libboot/target/classes org.libboot.Libboot download build/buildlib.spec build/repos.txt

ANT_CLASSPATH=$JDK_HOME/jre/lib/rt.jar
ANT_CLASSPATH=$ANT_CLASSPATH:$XSD2BEAN_HOME/build/lib/*
ANT_CLASSPATH=$ANT_CLASSPATH:$JDK_HOME/lib/tools.jar
export ANT_CLASSPATH
echo $ANT_CLASSPATH

ANT_ARGS="-Dant.home=$XSD2BEAN_HOME/build"
ANT_ARGS="$ANT_ARGS -Dlog4j.configuration=log4j.config"
export ANT_ARGS

JVM_ARGS="-ms16m -mx2000m -server -XX:MaxPermSize=128m -XX:+UseParallelGC -XX:MaxHeapFreeRatio=20 -XX:MinHeapFreeRatio=10 -XX:CompileThreshold=100"
export JVM_ARGS

$JDK_HOME/jre/bin/java $JVM_ARGS -classpath $ANT_CLASSPATH $ANT_ARGS org.apache.tools.ant.launch.Launcher -listener org.apache.tools.ant.listener.Log4jListener -f $XSD2BEAN_HOME/build/build.xml run-xsd2bean-test-suite

