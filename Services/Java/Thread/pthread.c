#include <pthread.h>
#include <stdio.h>
pthread_t pid;
void* thread_entity(void* arg)
{
    while(1){
        usleep(100);
        printf("I am new Thread\n");
    }
}
int main()
{
    pthread_create(&pid,NULL,thread_entity,NULL);
    while(1){
        usleep(100);
        printf("I am main\n");
    }
}