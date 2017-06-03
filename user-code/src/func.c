#include "main.h"


__IO uint16_t delay_count;

void SysTick_Handler(void) //1ms
{
	
	

	if (delay_count>0)
	{		delay_count--;	}	
	
}

void delay_ms(uint16_t delay_temp)
{
//	disk_timerproc();   // Disk timer process 
	delay_count=delay_temp;
	while (delay_count) {}
	
}




