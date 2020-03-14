#include <stm32f7xx.h>
#include "uart.h"
#include "string.h"

#define TOSEND "I am a string buffer\n"

int main(void){
	USART_init();
	STRING_setOutputFunction(USART_put);
	while(1){
		STRING_sendBuffer((uint8_t*)TOSEND,sizeof(TOSEND)/sizeof(uint8_t)-1);
	}
}


