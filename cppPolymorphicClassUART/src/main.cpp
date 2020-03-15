#include <stm32f7xx.h>
#include "uart.hpp"
#include "string.hpp"

#define TOSEND "I am a string buffer\n"

extern "C" void __cxa_pure_virtual() {};

int main(void){
	cUART uart;
	uart.init();

	cString stream(uart);
	while(1){
		if(stream.txFree() && (stream.byteCount() < 1000)){
			stream.sendBuffer((uint8_t*)TOSEND,sizeof(TOSEND)/sizeof(uint8_t)-1);
		}
	}
}


