#include<pthread.h>
#include<stdio.h>
#include<stdlib.h>
#include "SyncTest.h"


JNIEXPORT void JNICALL Java_SyncTest_getTid(JNIEnv *env, jobject c1){
	printf("java current tid:%lu-----\n",pthread_self());
	usleep(700);
} 
