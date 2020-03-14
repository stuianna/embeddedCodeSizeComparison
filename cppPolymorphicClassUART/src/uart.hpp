#ifndef _USART_HPP
#define _USART_HPP

#include <stdint.h>
#include "iointerface.hpp"

class cUART : public cIOInterface{

	public:
	cUART() = default;
	~cUART() = default;
	void init();
	virtual bool put(uint8_t byte) override;
	virtual bool isTxBusy() override;

	private:
		void gpioInit();
};

#endif
