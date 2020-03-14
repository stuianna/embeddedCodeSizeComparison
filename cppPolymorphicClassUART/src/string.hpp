#ifndef _STRING_HPP
#define _STRING_HPP
#include <stdint.h>
#include "iointerface.hpp"

class cString{

	public:
		cString(cIOInterface& targetInterface);
		~cString() = default;
		bool sendBuffer(uint8_t* buffer, uint8_t length);
		bool txFree();

	private:
		cIOInterface& interface;
};


#endif
