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

uint8_t cString::receiveBuffer(uint8_t *buffer,uint8_t length){
	uint8_t received;
	for(received = 0; received < length; received++){
		if(!cUART::get(buffer[received])){
			break;
		}
	}
	return received;
}

bool cString::txFree(){
	return cUART::isTxBusy();
}

uint32_t cString::byteCount(){
	return cUART::getByteCount();
}

uint8_t cString::lastByteSent(){
	return cUART::getLastByteSent();
}

void cString::resetByteCount(){
	cUART::resetByteCount();
}
