/*
 * CRC.h
 *
 *  Created on: Dec 8, 2020
 *      Author: thuylx
 */

#ifndef CRC16_H_
#define CRC16_H_

#include "main.h"
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>

uint16_t crc16(const uint8_t *buf, const uint16_t len);
//unsigned int CRC16(unsigned char *buf, int len);


#endif /* INC_CRC_H_ */
