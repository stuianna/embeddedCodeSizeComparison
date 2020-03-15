#include "string.hpp"

cString::cString(cIOInterface& targetInterface) : interface(targetInterface){
}

bool cString::sendBuffer(uint8_t* buffer, uint8_t length){

	for(uint32_t i = 0; i < length; i++){
		if(interface.put(buffer[i])){
			return true;
		}
	}
	return false;
}

bool cString::txFree(){
	return !interface.isTxBusy();
}

uint32_t cString::byteCount(){
	return interface.getByteCount();
}

uint8_t cString::lastByteSent(){
	return interface.getLastByteSent();
}

void cString::resetByteCount(){
	interface.resetByteCount();
}
