#ifndef _STRING_HPP
#define _STRING_HPP
#include <stdint.h>

class cString{

	public:
		static bool sendBuffer(uint8_t* buffer, uint8_t length);
		static bool txFree();
		static uint32_t byteCount();
		static uint8_t lastByteSent();
};


#endif
