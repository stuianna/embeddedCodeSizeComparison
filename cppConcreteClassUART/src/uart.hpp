#ifndef _USART_HPP
#define _USART_HPP

#include <stdint.h>

class cUART{

	public:
		cUART() : byteCount(0) {};
		~cUART() = default;
		void init();
		bool put(uint8_t byte);
		bool isTxBusy();
		uint32_t getByteCount();
		uint8_t getLastByteSent();
		void resetByteCount();

	private:
		void gpioInit();
		uint32_t byteCount;
		uint8_t lastByteSent;
};

#endif
