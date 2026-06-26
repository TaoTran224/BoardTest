include_guard(GLOBAL)

set(CMAKE_SYSTEM_NAME               Generic)
set(CMAKE_SYSTEM_PROCESSOR          arm)

set(CMAKE_C_COMPILER_FORCED TRUE)
set(CMAKE_CXX_COMPILER_FORCED TRUE)
set(CMAKE_C_COMPILER_ID GNU)
set(CMAKE_CXX_COMPILER_ID GNU)

# Some default GCC settings
set(TOOLCHAIN_PREFIX                arm-none-eabi-)
set(ARM_GNU_TOOLCHAIN_BIN_DIRS
    "C:/ST/STM32CubeCLT_1.21.0/GNU-tools-for-STM32/bin"
    "C:/Program Files (x86)/GNU Arm Embedded Toolchain/10 2021.10/bin"
    "C:/Program Files/GNU Arm Embedded Toolchain/10 2021.10/bin"
)

unset(ARM_NONE_EABI_GCC CACHE)
find_program(ARM_NONE_EABI_GCC ${TOOLCHAIN_PREFIX}gcc
    PATHS ${ARM_GNU_TOOLCHAIN_BIN_DIRS}
    NO_DEFAULT_PATH
)

if(NOT ARM_NONE_EABI_GCC)
    find_program(ARM_NONE_EABI_GCC ${TOOLCHAIN_PREFIX}gcc)
endif()

if(NOT ARM_NONE_EABI_GCC)
    message(FATAL_ERROR "arm-none-eabi-gcc not found. Install GNU Arm Embedded Toolchain or add it to PATH.")
endif()

get_filename_component(ARM_NONE_EABI_BIN_DIR "${ARM_NONE_EABI_GCC}" DIRECTORY)

set(CMAKE_C_COMPILER                "${ARM_NONE_EABI_BIN_DIR}/${TOOLCHAIN_PREFIX}gcc.exe")
set(CMAKE_ASM_COMPILER              ${CMAKE_C_COMPILER})
set(CMAKE_CXX_COMPILER              "${ARM_NONE_EABI_BIN_DIR}/${TOOLCHAIN_PREFIX}g++.exe")
set(CMAKE_LINKER                    "${ARM_NONE_EABI_BIN_DIR}/${TOOLCHAIN_PREFIX}g++.exe")
set(CMAKE_OBJCOPY                   "${ARM_NONE_EABI_BIN_DIR}/${TOOLCHAIN_PREFIX}objcopy.exe")
set(CMAKE_SIZE                      "${ARM_NONE_EABI_BIN_DIR}/${TOOLCHAIN_PREFIX}size.exe")

set(CMAKE_EXECUTABLE_SUFFIX_ASM     ".elf")
set(CMAKE_EXECUTABLE_SUFFIX_C       ".elf")
set(CMAKE_EXECUTABLE_SUFFIX_CXX     ".elf")

set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

# MCU specific flags
set(TARGET_FLAGS "-mcpu=cortex-m3 ")

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${TARGET_FLAGS}")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wall -Wextra -Wpedantic -fdata-sections -ffunction-sections")
if(CMAKE_BUILD_TYPE MATCHES Debug)
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -O0 -g3")
endif()
if(CMAKE_BUILD_TYPE MATCHES Release)
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Os -g0")
endif()

set(CMAKE_ASM_FLAGS "${CMAKE_C_FLAGS} -x assembler-with-cpp -MMD -MP")
set(CMAKE_CXX_FLAGS "${CMAKE_C_FLAGS} -fno-rtti -fno-exceptions -fno-threadsafe-statics")

set(CMAKE_C_LINK_FLAGS "${TARGET_FLAGS}")
set(CMAKE_C_LINK_FLAGS "${CMAKE_C_LINK_FLAGS} -T \"${CMAKE_SOURCE_DIR}/stm32f103c8tx_flash.ld\"")
set(CMAKE_C_LINK_FLAGS "${CMAKE_C_LINK_FLAGS} --specs=nano.specs")
set(CMAKE_C_LINK_FLAGS "${CMAKE_C_LINK_FLAGS} -Wl,-Map=${CMAKE_PROJECT_NAME}.map -Wl,--gc-sections")
set(CMAKE_C_LINK_FLAGS "${CMAKE_C_LINK_FLAGS} -Wl,--start-group -lc -lm -Wl,--end-group")
set(CMAKE_C_LINK_FLAGS "${CMAKE_C_LINK_FLAGS} -Wl,--print-memory-usage")

set(CMAKE_CXX_LINK_FLAGS "${CMAKE_C_LINK_FLAGS} -Wl,--start-group -lstdc++ -lsupc++ -Wl,--end-group")
