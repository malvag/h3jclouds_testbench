#!/bin/bash

#download H3, H3-Jclouds and S3Proxy subm
git submodule update --init --recursive
# -----------
#edit s3proxy's pom adding h3 dependency
sed 's/filesystem/h3/g' s3proxy/pom.xml > s3proxy/pom_new.xml
rm -f s3proxy/pom.xml
mv s3proxy/pom_new.xml s3proxy/pom.xml
# -----------
#populate s3proxy with its config file / keystore
cp config/s3proxy.conf s3proxy/
cp config/keystore.jks s3proxy/
# ---------

# remove JH3lib from .dockerignore
sed '$d' H3/.dockerignore > H3/.dockerignore2 
rm -f H3/.dockerignore
mv H3/.dockerignore2 H3/.dockerignore


#----------------------------------------------------------------------------------------------------------------
# edit 2 lines in JH3lib'pom to convert it to jdk 8 compatible
sed 's/<source>9/<source>8/g' H3/JH3lib/pom.xml > H3/JH3lib/pom_new.xml
rm -f H3/JH3lib/pom.xml 
mv H3/JH3lib/pom_new.xml  H3/JH3lib/pom.xml 

sed 's/<target>9/<target>8/g' H3/JH3lib/pom.xml > H3/JH3lib/pom_new.xml
rm -f H3/JH3lib/pom.xml 
mv H3/JH3lib/pom_new.xml  H3/JH3lib/pom.xml

# edit 3 lines in JH3.java to convert it to jdk 8 compatible
# change "import java.lang.ref.Cleaner;"
# to "import sun.misc.Cleaner;"
sed 's/import java.lang.ref.Cleaner;/import sun.misc.Cleaner;/g' H3/JH3lib/JH3/src/main/java/gr/forth/ics/JH3lib/JH3.java > H3/JH3lib/JH3/src/main/java/gr/forth/ics/JH3lib/JH3_new.java
rm -f H3/JH3lib/JH3/src/main/java/gr/forth/ics/JH3lib/JH3.java 
mv H3/JH3lib/JH3/src/main/java/gr/forth/ics/JH3lib/JH3_new.java   H3/JH3lib/JH3/src/main/java/gr/forth/ics/JH3lib/JH3.java 

#change "private static final Cleaner cleaner = Cleaner.create();"
# to  "private static Cleaner cleaner"
sed 's/private static final Cleaner cleaner = Cleaner.create();/private static Cleaner cleaner;/g' H3/JH3lib/JH3/src/main/java/gr/forth/ics/JH3lib/JH3.java > H3/JH3lib/JH3/src/main/java/gr/forth/ics/JH3lib/JH3_new.java
rm -f H3/JH3lib/JH3/src/main/java/gr/forth/ics/JH3lib/JH3.java 
mv H3/JH3lib/JH3/src/main/java/gr/forth/ics/JH3lib/JH3_new.java   H3/JH3lib/JH3/src/main/java/gr/forth/ics/JH3lib/JH3.java 

#change "cleaner.register(this, () -> {JH3Interface.INSTANCE.H3_Free(handle);});"
# to "cleaner = sun.misc.Cleaner.create(this, () -> {JH3Interface.INSTANCE.H3_Free(handle);});"
sed 's/cleaner.register(this, () -> {JH3Interface.INSTANCE.H3_Free(handle);});/cleaner = sun.misc.Cleaner.create(this, () -> {JH3Interface.INSTANCE.H3_Free(handle);});/g' H3/JH3lib/JH3/src/main/java/gr/forth/ics/JH3lib/JH3.java > H3/JH3lib/JH3/src/main/java/gr/forth/ics/JH3lib/JH3_new.java
rm -f H3/JH3lib/JH3/src/main/java/gr/forth/ics/JH3lib/JH3.java 
mv H3/JH3lib/JH3/src/main/java/gr/forth/ics/JH3lib/JH3_new.java   H3/JH3lib/JH3/src/main/java/gr/forth/ics/JH3lib/JH3.java 



