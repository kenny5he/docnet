#!bin/bash

function formatnamenode(){
	if [ "$2" = "0" ] ; then
		#hadoop 初始化 namenode
		hadoop namenode -format
	fi
	
	#hadoop 删除 name
	rm -rf /usr/local/src/hadoop-2.8.3/dfs/name/*
	
	#hadoop 删除 data
	rm -rf /usr/local/src/hadoop-2.8.3/dfs/data/*
	
	#hadoop 删除 tmp
	rm -rf /usr/local/src/hadoop-2.8.3/tmp/dfs/*
}

function main(){
	if [ "$1" = "format" ] ; then
		echo 'start hadoop namenode format'
		formatnamenode
		echo 'namenode format success'
	fi
}

main