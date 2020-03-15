#ifndef _STRING_HPP
#define _STRING_HPP
#include <stdint.h>
#include "uart.hpp"

class cString{

	public:
		cString(cUART& targetInterface);
		~cString() = default;
		bool sendBuffer(uint8_t* buffer, uint8_t length);
		bool txFree();
		uint32_t byteCount();

	private:
		cUART& interface;
};


#endif
