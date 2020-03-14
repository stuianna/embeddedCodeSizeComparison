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

