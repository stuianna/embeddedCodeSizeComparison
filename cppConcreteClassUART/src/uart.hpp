#ifndef _USART_HPP
#define _USART_HPP

#include <stdint.h>

class cUART{

	public:
	cUART() = default;
	~cUART() = default;
	void init();
	bool put(uint8_t byte);

	private:
		void gpioInit();
};

#endif
