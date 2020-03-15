#include "string.hpp"

bool (*cString::outputFunction)(uint8_t) = 0;
bool (*cString::txFreeFunction)(void) = 0;
uint32_t (*cString::byteCountFunction)(void) = 0;

bool cString::sendBuffer(uint8_t* buffer, uint8_t length){

	if(!outputFunction){
		return true;
	}

	for(uint32_t i = 0; i < length; i++){
		if(outputFunction(buffer[i])){
			return true;
		}
	}
	return false;
}

bool cString::txFree(){
	if(!txFreeFunction){
		return false;
	}
	return txFreeFunction();
}

uint32_t cString::byteCount(){
	if(!byteCountFunction){
		return 0;
	}
	return byteCountFunction();
}

void cString::setOutputFunction(bool (*out)(uint8_t)){
	outputFunction = out;
}

void cString::setTxFreeFunction(bool (*free)(void)){
	txFreeFunction = free;
}

void cString::setByteCountFunction(uint32_t (*bc)(void)){
	byteCountFunction = bc;
}
