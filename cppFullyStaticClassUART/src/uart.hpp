#ifndef _USART_HPP
#define _USART_HPP

#include <stdint.h>

class cUART{

	public:
	static void init();
	static bool put(uint8_t byte);
	static bool isTxBusy();
	static uint32_t getByteCount();

	private:
		static void gpioInit();
		static uint32_t byteCount;
};

#endif
