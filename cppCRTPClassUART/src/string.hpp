#ifndef _STRING_HPP
#define _STRING_HPP
#include <stdint.h>
#include "iointerface.hpp"

template <typename T>
class cString{

	public:
		cString(cIOInterface<T>& targetInterface) : interface(targetInterface) {};
		~cString() = default;
		bool sendBuffer(uint8_t* buffer, uint8_t length){
			for(uint32_t i = 0; i < length; i++){
				if(interface.put(buffer[i])){
					return true;
				}
			}
			return false;
		}

		bool txFree(){
			return interface.isTxBusy();
		}

		uint32_t byteCount(){
			return interface.getByteCount();
		}

		uint8_t lastByteSent(){
			return interface.getLastByteSent();
		}

	private:
		cIOInterface<T>& interface;
};


#endif
