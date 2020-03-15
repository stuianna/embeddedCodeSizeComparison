#include <stm32f7xx.h>
#include "uart.hpp"
#include "string.hpp"

#define TOSEND "I am a string buffer\n"

int main(void){
	cUART::init();
	uint8_t buffer[4];
	while(1){
		if(cString::receiveBuffer(buffer,4)){
			cString::sendBuffer(buffer,4);
		}
		if(cString::txFree() && (cString::byteCount() < 1000)){
			cString::sendBuffer((uint8_t*)TOSEND,sizeof(TOSEND)/sizeof(uint8_t)-1);
		}
		if(cString::lastByteSent() == '0'){
			cString::resetByteCount();
		}
	}
}


