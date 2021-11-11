#!bin/sh
cd ~/workspace/distributed-sys
# start configservice
java -jar /Users/apaye/workspace/git/sourcecode/apollo/apollo-configservice/target/apollo-configservice-0.11.0-SNAPSHOT.jar &
# start adminservice
java -jar /Users/apaye/workspace/git/sourcecode/apollo/apollo-adminservice/target/apollo-adminservice-0.11.0-SNAPSHOT.jar &
# start portal
java -jar /Users/apaye/workspace/git/sourcecode/apollo/apollo-portal/target/apollo-portal-0.11.0-SNAPSHOT.jar &
