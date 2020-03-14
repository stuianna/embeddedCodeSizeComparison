#ifndef _IOINTERFACE_HPP
#define _IOINTERFACE_HPP

#include <stdint.h>

class cIOInterface{

	public:
		cIOInterface() = default;
		~cIOInterface() = default;
		virtual bool put(uint8_t byte) = 0;
		virtual bool isTxBusy() = 0;
};

#endif
