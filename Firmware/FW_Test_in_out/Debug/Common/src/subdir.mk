################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (9-2020-q2-update)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../Common/src/calculator.c \
../Common/src/log.c 

OBJS += \
./Common/src/calculator.o \
./Common/src/log.o 

C_DEPS += \
./Common/src/calculator.d \
./Common/src/log.d 


# Each subdirectory must supply rules for building sources it contributes
Common/src/calculator.o: ../Common/src/calculator.c Common/src/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m3 -std=gnu11 -g3 -DDEBUG -DUSE_HAL_DRIVER -DSTM32F103xB -c -I../Core/Inc -I../Drivers/STM32F1xx_HAL_Driver/Inc -I../Drivers/STM32F1xx_HAL_Driver/Inc/Legacy -I../Drivers/CMSIS/Device/ST/STM32F1xx/Include -I../Drivers/CMSIS/Include -I../App -I../App/Inc -I../Common -I../Common/Inc -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -MMD -MP -MF"Common/src/calculator.d" -MT"$@" --specs=nano.specs -mfloat-abi=soft -mthumb -o "$@"
Common/src/log.o: ../Common/src/log.c Common/src/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m3 -std=gnu11 -g3 -DDEBUG -DUSE_HAL_DRIVER -DSTM32F103xB -c -I../Core/Inc -I../Drivers/STM32F1xx_HAL_Driver/Inc -I../Drivers/STM32F1xx_HAL_Driver/Inc/Legacy -I../Drivers/CMSIS/Device/ST/STM32F1xx/Include -I../Drivers/CMSIS/Include -I../App -I../App/Inc -I../Common -I../Common/Inc -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -MMD -MP -MF"Common/src/log.d" -MT"$@" --specs=nano.specs -mfloat-abi=soft -mthumb -o "$@"

