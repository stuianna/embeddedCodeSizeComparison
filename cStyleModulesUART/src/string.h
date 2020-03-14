#ifndef _STRING_H
#define _STRING_H

#include <stdint.h>

uint8_t STRING_sendBuffer(uint8_t *buffer, uint32_t length);
void STRING_setOutputFunction(uint8_t (*out_fun)(uint8_t));

#endif
