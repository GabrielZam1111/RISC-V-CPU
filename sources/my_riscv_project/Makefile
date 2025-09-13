# Toolchain
CC = riscv-none-elf-gcc
CXX = riscv-none-elf-g++
OBJCOPY = riscv-none-elf-objcopy
OBJDUMP = riscv-none-elf-objdump
SIZE = riscv-none-elf-size

# Directories
SRC_DIR = src
BUILD_DIR = build
LINKER_DIR = linker

# Compiler flags
CFLAGS = -march=rv32im -mabi=ilp32 -nostdlib -nostartfiles -O2 -Wall -Wextra
CXXFLAGS = $(CFLAGS) -std=c++17 -fno-exceptions -fno-rtti -fno-use-cxa-atexit
# Add garbage collection for smaller binaries
LDFLAGS = -T $(LINKER_DIR)/memory_layout.ld -Wl,--gc-sections

# Source files - automatically detect C and C++ files
C_SOURCES = $(wildcard $(SRC_DIR)/*.c)
CXX_SOURCES = $(wildcard $(SRC_DIR)/*.cpp)
ASM_SOURCES = $(wildcard $(SRC_DIR)/*.S)

# Object files
C_OBJECTS = $(C_SOURCES:$(SRC_DIR)/%.c=$(BUILD_DIR)/%.o)
CXX_OBJECTS = $(CXX_SOURCES:$(SRC_DIR)/%.cpp=$(BUILD_DIR)/%.o)
ASM_OBJECTS = $(ASM_SOURCES:$(SRC_DIR)/%.S=$(BUILD_DIR)/%.o)
ALL_OBJECTS = $(C_OBJECTS) $(CXX_OBJECTS) $(ASM_OBJECTS)

TARGET = $(BUILD_DIR)/program

# Create build director
$(shell mkdir $(BUILD_DIR) 2>nul || echo off)

all: $(TARGET).elf $(TARGET).bin $(TARGET).hex $(TARGET).mem $(TARGET).dump $(TARGET).map $(TARGET)_numeric.dump

# Link all object files
$(TARGET).elf: $(ALL_OBJECTS) $(LINKER_DIR)/memory_layout.ld
	$(CXX) $(CXXFLAGS) $(LDFLAGS) -o $@ $(ALL_OBJECTS)
	$(SIZE) $@

# Compile C++ files (add -ffunction-sections for better garbage collection)
$(BUILD_DIR)/%.o: $(SRC_DIR)/%.cpp
	$(CXX) $(CXXFLAGS) -ffunction-sections -fdata-sections -c $< -o $@

# Compile C files
$(BUILD_DIR)/%.o: $(SRC_DIR)/%.c
	$(CC) $(CFLAGS) -ffunction-sections -fdata-sections -c $< -o $@

# Assemble assembly files
$(BUILD_DIR)/%.o: $(SRC_DIR)/%.S
	$(CC) $(CFLAGS) -c $< -o $@

$(TARGET).bin: $(TARGET).elf
	$(OBJCOPY) -O binary $< $@

# Generate .hex file with Verilog format
$(TARGET).hex: $(TARGET).elf
	$(OBJCOPY) -O verilog --verilog-data-width=4 $< $@

# Generate .mem file (copy of hex with different extension)
$(TARGET).mem: $(TARGET).hex
	copy "$(subst /,\,$<)" "$(subst /,\,$@)"

# Add memory map output
$(TARGET).map: $(TARGET).elf
	$(OBJDUMP) -h $< > $@

$(TARGET).dump: $(TARGET).elf
	$(OBJDUMP) -d -M no-aliases $< > $@

$(TARGET)_numeric.dump: $(TARGET).elf
	$(OBJDUMP) -d -M no-aliases,numeric $< > $@
clean:
	del /Q $(BUILD_DIR)\* 2>nul || echo off

.PHONY: all clean