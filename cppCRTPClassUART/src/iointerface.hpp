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
		bool isTxBusy(){
			return this->underlying().isTxBusy();
		}
		uint32_t getByteCount(){
			return this->underlying().getByteCount();
		}
		uint8_t getLastByteSent(){
			return this->underlying().getLastByteSent();
		}
		void resetByteCount(){
			this->underlying().resetByteCount();
		}
		bool get(uint8_t& byte){
			return this->underlying().get(byte);
		}

	private:
		friend T;
		cIOInterface(){};
		T& underlying() { return static_cast<T&>(*this); };
};

#endif
