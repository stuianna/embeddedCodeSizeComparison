#ifndef _USART_HPP
#define _USART_HPP

#include <stdint.h>
#include "iointerface.hpp"

class cUART : public cIOInterface<cUART>{

	public:
		explicit cUART() : byteCount(0) {};
		~cUART() = default;
		void init();
		bool put(uint8_t byte);
		bool isTxBusy();
		uint32_t getByteCount();
		uint8_t getLastByteSent();
		void resetByteCount();
		bool get(uint8_t& byte);

	private:
		void gpioInit();
		uint32_t byteCount;
		uint8_t lastByteSent;
};

#endif
