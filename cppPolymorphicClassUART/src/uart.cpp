#include "uart.hpp"

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

static void GPIO_setUARTFunction(GPIO_TypeDef* port, uint8_t pin);

void cUART::init(){
	gpioInit();
	SET_BIT(RCC->APB1ENR,USART_CLOCK);
	USART->BRR = (uint32_t)(CORE_CLOCK/BAUD);
	USART->CR1 |= USART_CR1_RE;
	USART->CR1 |= USART_CR1_TE;
	USART->CR1 |= USART_CR1_UE;
}

void cUART::gpioInit(){
	SET_BIT(RCC->AHB1ENR,GPIO_PORT_CLOCK);
	GPIO_setUARTFunction(GPIO_PORT,GPIO_PIN_RX);
	GPIO_setUARTFunction(GPIO_PORT,GPIO_PIN_TX);
}

void GPIO_setUARTFunction(GPIO_TypeDef* port, uint8_t pin){
	port->MODER |= (uint32_t)(0x2 << pin * 2);
	port->AFR[pin >> 3] &= ~(uint32_t)(0xF << ((pin - (pin & 0x8)) * 4));
	port->AFR[pin >> 3] |= (uint32_t)GPIO_ALT_NUMBER << ( (pin - (pin & 0x8)) * 4);
}

bool cUART::put(uint8_t byte){
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

