#include <stm32f7xx.h>
#include "uart.hpp"
#include "string.hpp"

#define TOSEND "I am a string buffer\n"

int main(void){
	cUART uart;
	uint8_t buffer[4];
	uart.init();
	cString stream(uart);
	while(1){
		if(stream.receiveBuffer(buffer,4)){
			stream.sendBuffer(buffer,4);
		}
		if(stream.txFree() && (stream.byteCount() < 1000)){
			stream.sendBuffer((uint8_t*)TOSEND,sizeof(TOSEND)/sizeof(uint8_t)-1);
		}
		if(stream.lastByteSent() == 0){
			stream.resetByteCount();
		}
	}
}


