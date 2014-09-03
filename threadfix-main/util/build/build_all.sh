cd ../../..

if [[ $1 ]]
then
    echo "Got license file: $1"
    cp $1 threadfix-main/src/main/resources/threadfix.license
    mvn clean install -P enterprise -DskipTests
    rm threadfix-main/src/main/resources/threadfix.license

else
    mvn clean install -DskipTests
fi

VERSION=2.1
ARTIFACTS_FOLDER=$(pwd)/artifacts

rm -r $ARTIFACTS_FOLDER
mkdir $ARTIFACTS_FOLDER

FOLDER_NAME=Build
rm -r $FOLDER_NAME
mkdir $FOLDER_NAME

# Build cli
FOLDER_NAME=Build/ThreadFix-CLI-$VERSION
mkdir $FOLDER_NAME
cp threadfix-cli/target/threadfix-cli-$VERSION-SNAPSHOT-jar-with-dependencies.jar $FOLDER_NAME/tfcli.jar
cp threadfix-cli/README.md $FOLDER_NAME
cd  $FOLDER_NAME
zip  -q ThreadFix-CLI-$VERSION.zip -r ./*
cp ThreadFix-CLI-$VERSION.zip $ARTIFACTS_FOLDER
cd ../../

# Build endpoint cli
FOLDER_NAME=Build/ThreadFix-EndpointCLI-$VERSION
mkdir $FOLDER_NAME
cp threadfix-cli-endpoints/target/threadfix-endpoint-cli-$VERSION-SNAPSHOT-jar-with-dependencies.jar $FOLDER_NAME/endpoints.jar
cp threadfix-cli-endpoints/README $FOLDER_NAME
cd  $FOLDER_NAME
zip  -q ThreadFix-EndpointCLI-$VERSION.zip -r ./*
cp ThreadFix-EndpointCLI-$VERSION.zip $ARTIFACTS_FOLDER
cd ../../

# Build scan agent

# FOLDER_NAME=Build/ThreadFix-ScanAgent-$VERSION
# rm -r $FOLDER_NAME
# mkdir $FOLDER_NAME
# cp threadfix-scanagent/target/threadfix-scanagent-$VERSION-SNAPSHOT-jar-with-dependencies.jar $FOLDER_NAME/scanagent.jar
# cp threadfix-scanagent/README $FOLDER_NAME
# cp threadfix-scanagent/scanagent.properties $FOLDER_NAME
# cp threadfix-scanagent/zapStarter.jar $FOLDER_NAME
# cp threadfix-scanagent/burp-agent.jar $FOLDER_NAME
# cd  $FOLDER_NAME
# zip  -q ThreadFix-ScanAgent-$VERSION.zip -r ./*
# cp ThreadFix-ScanAgent-$VERSION.zip $ARTIFACTS_FOLDER
# cd ../../

# Build ZAP plugin
FOLDER_NAME=Build/ThreadFix-ZapPlugin-$VERSION
mkdir $FOLDER_NAME
cp threadfix-scanner-plugin/zaproxy/target/Zap-Plugin-$VERSION-SNAPSHOT-jar-with-dependencies.jar $FOLDER_NAME/threadfix-release-2.zap
cp threadfix-scanner-plugin/zaproxy/README $FOLDER_NAME
cd  $FOLDER_NAME
zip  -q ThreadFix-ZapPlugin-$VERSION.zip -r ./*
cp ThreadFix-ZapPlugin-$VERSION.zip $ARTIFACTS_FOLDER
cd ../../

# Build Burp plugin
FOLDER_NAME=Build/ThreadFix-BurpPlugin-$VERSION
mkdir $FOLDER_NAME
cp threadfix-scanner-plugin/burp/target/threadfix-release-2-jar-with-dependencies.jar $FOLDER_NAME/threadfix-release-2.jar
cp threadfix-scanner-plugin/burp/README $FOLDER_NAME
cd  $FOLDER_NAME
zip  -q ThreadFix-BurpPlugin-$VERSION.zip -r ./*
cp ThreadFix-BurpPlugin-$VERSION.zip $ARTIFACTS_FOLDER
cd ../../

# Build IntelliJ--export intellij.zip to Build folder using "Prepare module for deployment"
FOLDER_NAME=Build/ThreadFix-IntelliJPlugin-$VERSION
mkdir $FOLDER_NAME
cp $BUILD_FILES/intellij.zip $FOLDER_NAME
cp threadfix-ide-plugin/intellij/README $FOLDER_NAME
cd  $FOLDER_NAME
zip  -q ThreadFix-IntelliJPlugin-$VERSION.zip -r ./*
cp ThreadFix-IntelliJPlugin-$VERSION.zip $ARTIFACTS_FOLDER
cd ../../

# Build Eclipse--export 
FOLDER_NAME=Build/ThreadFix-EclipsePlugin-$VERSION
mkdir $FOLDER_NAME
cp $BUILD_FILES/com.denimgroup.threadfix.plugin.eclipse.views.VulnerabilitiesView_0.2.0.jar $FOLDER_NAME
cp threadfix-ide-plugin/eclipse/README $FOLDER_NAME
cd  $FOLDER_NAME
zip  -q ThreadFix-EclipsePlugin-$VERSION.zip -r ./*
cp ThreadFix-EclipsePlugin-$VERSION.zip $ARTIFACTS_FOLDER
cd ../../

# Build Zip
cd Build
cp -r $BUILD_FILES/ThreadFixBase .

rm -r ThreadFix
pwd
cp ../threadfix-main/src/main/resources/threadfix-backup.script ThreadFixBase/database/threadfix-backup.script
cp ../threadfix-main/src/main/resources/threadfix-backup.script ThreadFixBase/database/threadfix.script
cp ../threadfix-main/util/zip/* ThreadFixBase

cp -r ThreadFixBase ThreadFix

if [[ $1 ]]
then
  echo "Adding scanagent stuff to ThreadFix package"
  cd ThreadFix
  mkdir scanagent
  cd ../
  cp ../threadfix-scanagent/target/threadfix-scanagent-$VERSION-SNAPSHOT-jar-with-dependencies.jar ThreadFix/scanagent/scanagent.jar
  cp ../threadfix-scanagent/scanagent.properties ThreadFix/scanagent/scanagent.properties
  cp ../threadfix-scanagent/burp-agent.jar ThreadFix/scanagent/burp-agent.jar 
  cp ../threadfix-scanagent/zapStarter.jar ThreadFix/scanagent/zapStarter.jar 
fi

cp ../threadfix-cli/target/threadfix-cli-$VERSION-SNAPSHOT-jar-with-dependencies.jar ThreadFix/command-line-interface/tfcli.jar

cp ../threadfix-main/target/threadfix-$VERSION-SNAPSHOT.war ThreadFix/tomcat/webapps/
mv ThreadFix/tomcat/webapps/threadfix-$VERSION-SNAPSHOT.war ThreadFix/tomcat/webapps/threadfix.war
cp ../threadfix-main/src/main/resources/threadfix-backup.script ThreadFix/database/
cp ThreadFix/database/threadfix-backup.script ThreadFix/database/threadfix.script

zip -q ThreadFix_$VERSION.zip -r ThreadFix
mv ThreadFix_$VERSION.zip ../artifacts
cd ..