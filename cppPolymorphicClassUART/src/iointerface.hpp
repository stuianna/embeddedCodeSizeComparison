#ifndef _IOINTERFACE_HPP
#define _IOINTERFACE_HPP

#include <stdint.h>

class cIOInterface{

	public:
		cIOInterface()  {};
		~cIOInterface() = default;
		virtual bool put(uint8_t byte) = 0;
		virtual bool isTxBusy() = 0;
		virtual uint32_t getByteCount()  = 0;
		virtual uint8_t getLastByteSent() = 0;
		virtual void resetByteCount() = 0;
		virtual bool get(uint8_t& byte) = 0;
};

#endif
