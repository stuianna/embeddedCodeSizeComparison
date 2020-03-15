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
		void resetByteCount(){
			return interface.resetByteCount();
		}
		uint8_t receiveBuffer(uint8_t *buffer,uint8_t length){
			uint8_t received;
			for(received = 0; received < length; received++){
				if(!interface.get(buffer[received])){
					break;
				}
			}
			return received;
		}

	private:
		cIOInterface<T>& interface;
};


#endif
