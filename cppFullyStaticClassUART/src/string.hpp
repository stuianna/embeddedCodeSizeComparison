#ifndef _STRING_HPP
#define _STRING_HPP
#include <stdint.h>

class cString{

	public:
		static bool sendBuffer(uint8_t* buffer, uint8_t length);
		static void setOutputFunction(bool (*out)(uint8_t));
		static void setTxFreeFunction(bool (*out)(void));
		static void setByteCountFunction(uint32_t (*bc)(void));
		static bool txFree();
		static uint32_t byteCount();

	private:
		static bool (*outputFunction)(uint8_t byte);
		static bool (*txFreeFunction)(void);
		static uint32_t (*byteCountFunction)(void);
};


#endif
