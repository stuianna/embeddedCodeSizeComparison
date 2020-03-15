#ifndef _USART_HPP
#define _USART_HPP

#include <stdint.h>

class cUART{

	public:
	static void init();
	static bool put(uint8_t byte);
	static bool isTxBusy();
	static uint32_t getByteCount();
	static uint8_t getLastByteSent();
	static void resetByteCount();
	static bool get(uint8_t& byte);

	private:
		static void gpioInit();
		static uint32_t byteCount;
		static uint8_t lastByteSent;
};

#endif
