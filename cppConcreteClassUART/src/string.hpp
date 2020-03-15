#ifndef _STRING_HPP
#define _STRING_HPP
#include <stdint.h>
#include "uart.hpp"

class cString{

	public:
		cString(cUART& targetInterface);
		~cString() = default;
		bool sendBuffer(uint8_t* buffer, uint8_t length);
		uint8_t receiveBuffer(uint8_t* buffer, uint8_t length);
		bool txFree();
		uint32_t byteCount();
		uint8_t lastByteSent();
		void resetByteCount();

	private:
		cUART& interface;
};


#endif
