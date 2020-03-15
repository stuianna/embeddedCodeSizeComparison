#include "string.hpp"
#include "uart.hpp"

bool cString::sendBuffer(uint8_t* buffer, uint8_t length){
	for(uint32_t i = 0; i < length; i++){
		if(cUART::put(buffer[i])){
			return true;
		}
	}
	return false;
}
