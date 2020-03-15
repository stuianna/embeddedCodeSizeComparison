#include <stm32f7xx.h>
#include "uart.hpp"
#include "string.hpp"

#define TOSEND "I am a string buffer\n"

int main(void){
	cUART::init();
	cString::setOutputFunction(cUART::put);
	cString::setTxFreeFunction(cUART::isTxBusy);
	cString::setByteCountFunction(cUART::getByteCount);
	while(1){
		if(cString::txFree() && (cString::byteCount() < 1000)){
			cString::sendBuffer((uint8_t*)TOSEND,sizeof(TOSEND)/sizeof(uint8_t)-1);
		}
	}
}


