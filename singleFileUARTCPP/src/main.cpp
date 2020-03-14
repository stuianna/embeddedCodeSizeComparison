#include <stm32f7xx.h>

#define GPIO_PORT GPIOD
#define GPIO_PORT_CLOCK RCC_AHB1ENR_GPIODEN
#define GPIO_ALT_NUMBER 7
#define GPIO_PIN_TX 8
#define GPIO_PIN_RX 9
#define USART_CLOCK RCC_APB1ENR_USART3EN
#define USART USART3
#define USART_TIMEOUT 0x37FF
#define CORE_CLOCK 16000000.
#define BAUD 115200.

#define TOSEND "I am a string buffer\n"

void USART_init();
bool USART_put(uint8_t byte);
void GPIO_init();
void GPIO_setUARTFunction(GPIO_TypeDef* port, uint8_t pin);
bool STRING_sendBuffer(uint8_t *buffer, uint32_t length);

int main(void){
	USART_init();
	while(1){
		STRING_sendBuffer((uint8_t*)TOSEND,sizeof(TOSEND)/sizeof(uint8_t)-1);
	}
}

void USART_init(){
	GPIO_init();
	SET_BIT(RCC->APB1ENR,USART_CLOCK);
	USART->BRR = (uint32_t)(CORE_CLOCK/BAUD);
	USART->CR1 |= USART_CR1_RE;
	USART->CR1 |= USART_CR1_TE;
	USART->CR1 |= USART_CR1_UE;
}

bool USART_put(uint8_t byte){
	uint16_t timeout = USART_TIMEOUT;
	while(!(USART->ISR & USART_ISR_TXE) && timeout){
		timeout--;
	}
	if(!timeout){
		return true;
	}
	USART->TDR = byte;
	return false;
}

void GPIO_init(){
	SET_BIT(RCC->AHB1ENR,GPIO_PORT_CLOCK);
	GPIO_setUARTFunction(GPIO_PORT,GPIO_PIN_RX);
	GPIO_setUARTFunction(GPIO_PORT,GPIO_PIN_TX);
}

void GPIO_setUARTFunction(GPIO_TypeDef* port, uint8_t pin){
	port->MODER |= (uint32_t)(0x2 << pin * 2);
	port->AFR[pin >> 3] &= ~(uint32_t)(0xF << ((pin - (pin & 0x8)) * 4));
	port->AFR[pin >> 3] |= (uint32_t)GPIO_ALT_NUMBER << ( (pin - (pin & 0x8)) * 4);
}

bool STRING_sendBuffer(uint8_t *buffer, uint32_t length){
	for(uint32_t i = 0; i < length; i++){
		if(USART_put(buffer[i])){
			return true;
		}
	}
	return false;
}
