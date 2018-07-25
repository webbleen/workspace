/*************************************************************************
	> File Name: main.cpp
	> Author: 
	> Mail: 
	> Created Time: Wed 25 Jul 2018 12:35:09 PM CST
 ************************************************************************/

#include<stdio.h>
#include<event.h>


void on_time(int sock, short event, void *arg)
{
    printf("Hello,World!\n");

    struct timeval tv;
    tv.tv_sec = 1;
    tv.tv_usec = 0;

    // 事件执行后，默认会被删除，所以需要重新添加;
    event_add((struct event*)arg, &tv);
}

int main()
{
    //  初始化事件  
    event_init();

    //  设置定时器回调函数  
    struct event ev_time;
    evtimer_set(&ev_time, on_time, &ev_time);

    //1s运行一次func函数
    struct timeval tv;
    tv.tv_sec = 1;
    tv.tv_usec = 0;

    //添加到事件循环中
    event_add(&ev_time, &tv);
    //程序等待就绪事件并执行事件处理
    event_dispatch();
    return 0;
}
