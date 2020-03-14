#ifndef _STRING_HPP
#define _STRING_HPP
#include <stdint.h>

class cString{

	public:
		static bool sendBuffer(uint8_t* buffer, uint8_t length);
		static void setOutputFunction(bool (*out)(uint8_t));

	private:
		static bool (*outputFunction)(uint8_t byte);
};


#endif
