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

int main(void){

	// GPIO Clock
	SET_BIT(RCC->AHB1ENR,GPIO_PORT_CLOCK);

	// TX Pin
	GPIO_PORT->MODER |= (0x2 << GPIO_PIN_TX * 2);
	GPIO_PORT->AFR[GPIO_PIN_TX >> 3] &= ~(uint32_t)(0xF << ((GPIO_PIN_TX - (GPIO_PIN_TX & 0x8)) * 4));
	GPIO_PORT->AFR[GPIO_PIN_TX >> 3] |= GPIO_ALT_NUMBER << ( (GPIO_PIN_TX - (GPIO_PIN_TX & 0x8)) * 4);

	// RX Pin
	GPIO_PORT->MODER |= (0x2 << GPIO_PIN_RX * 2);
	GPIO_PORT->AFR[GPIO_PIN_RX >> 3] &= ~(uint32_t)(0xF << ((GPIO_PIN_RX - (GPIO_PIN_RX & 0x8)) * 4));
	GPIO_PORT->AFR[GPIO_PIN_RX >> 3] |= GPIO_ALT_NUMBER << ( (GPIO_PIN_RX - (GPIO_PIN_RX & 0x8)) * 4);

	// UART Init
	SET_BIT(RCC->APB1ENR,USART_CLOCK);
	USART->BRR = (uint32_t)(CORE_CLOCK/BAUD);
	USART->CR1 |= USART_CR1_RE;
	USART->CR1 |= USART_CR1_TE;
	USART->CR1 |= USART_CR1_UE;

	// Combined put character and print buffer
	int timeout;
	while(1){
		timeout = USART_TIMEOUT;
		for(uint32_t i = 0; i < sizeof(TOSEND) / sizeof(uint8_t)-1; i++){
			while(!(USART->ISR & USART_ISR_TXE) && timeout){
				timeout--;
			}
			if(!timeout){
				continue;
			}
			USART->TDR = TOSEND[i];
		}
	}
}


