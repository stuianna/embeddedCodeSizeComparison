#ifndef _USART_HPP
#define _USART_HPP

#include <stdint.h>

class cUART{

	public:
	static void init();
	static bool put(uint8_t byte);
	static bool isTxBusy();

	private:
		static void gpioInit();
};

#endif
