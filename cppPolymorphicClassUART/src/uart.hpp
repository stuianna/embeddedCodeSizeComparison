#ifndef _USART_HPP
#define _USART_HPP

#include <stdint.h>
#include "iointerface.hpp"

class cUART : public cIOInterface{

	public:
	cUART() : byteCount(0) {};
	~cUART() = default;
	void init();
	virtual bool put(uint8_t byte) override;
	virtual bool isTxBusy() override;
	virtual uint32_t getByteCount() override;
	virtual uint8_t getLastByteSent() override;
	virtual void resetByteCount() override;
	virtual bool get(uint8_t& byte) override;

	private:
		void gpioInit();
		uint32_t byteCount;
		uint8_t lastByteSent;
};

#endif
