#ifndef _IOINTERFACE_HPP
#define _IOINTERFACE_HPP

#include <stdint.h>

template <typename T>
class cIOInterface{

	public:
		~cIOInterface() = default;
		bool put(uint8_t byte){
			return this->underlying().put(byte);
		}

	private:
		friend T;
		cIOInterface(){};
		T& underlying() { return static_cast<T&>(*this); };
};

#endif
