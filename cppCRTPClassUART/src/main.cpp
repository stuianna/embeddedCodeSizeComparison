#include <stm32f7xx.h>
#include "uart.hpp"
#include "string.hpp"

#define TOSEND "I am a string buffer\n"

int main(void){
	cUART uart;
	uart.init();
	cString<cUART> stream(uart);
	while(1){
		if(stream.txFree()){
			stream.sendBuffer((uint8_t*)TOSEND,sizeof(TOSEND)/sizeof(uint8_t)-1);
		}
	}
}


