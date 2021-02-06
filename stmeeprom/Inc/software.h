

#ifndef __SOFTWARE_H__
#define __SOFTWARE_H__

#define UART_W_ADDRESS 0x7500
#define UART_R_ADDRESS 0x7501


#define RESET_VECTOR_ADDRESS_MSB 0xFFFE
#define RESET_VECTOR_ADDRESS_LSB 0xFFFF

#define RESET_VECTOR 0x8000
#define NMI_VECTOR   0x0000
#define SOFTWARE_BEGIN RESET_VECTOR
#define INST_NOP 0x12


#ifdef __cplusplus
extern 
"C" {
#endif

#include "stm32f4xx_hal.h"



uint8_t romimage[] = {0xFF, 0xFF};


#ifdef __cplusplus
}
#endif

#endif
