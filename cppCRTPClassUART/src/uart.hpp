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

	private:
		void gpioInit();
		uint32_t byteCount;
};

#endif
