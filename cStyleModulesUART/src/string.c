#include "string.h"

static uint8_t (*outputFunction)(uint8_t) = 0;

void STRING_setOutputFunction(uint8_t (*out_fun)(uint8_t)){
	outputFunction = out_fun;
}

uint8_t STRING_sendBuffer(uint8_t *buffer, uint32_t length){

	if(!outputFunction){
		return 1;
	}

	for(uint32_t i = 0; i < length; i++){
		if(outputFunction(buffer[i])){
			return 1;
		}
	}
	return 0;
}
