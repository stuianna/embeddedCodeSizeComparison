# Project name
PROJECT=base

# User defined global definitions
DEFS =

# Comparison targets
REFERENCEDIRCPP=minimumReferenceCPP
CPPSTATICCLASS=cppFullyStaticClassUART
CPPCONCRETECLASS=cppConcreteClassUART
CPPPOLYCLASS=cppPolymorphicClassUART
CPPCRPTCLASS=cppCRTPClassUART

# Directory Structure
CURRDIR=.
BINDIR=$(CURRDIR)/bin
INCDIR=$(CURRDIR)/inc
INCDIR+=$(CURRDIR)/lib
SRCDIR=$(CURRDIR)/src
LIBDIR=$(CURRDIR)/lib
OBJDIR=$(CURRDIR)/obj

STARTUP = startup_stm32f767xx.s
LDSCRIPT=STM32F767ZITx_FLASH.ld
OPENOCD_INTERFACE=stlink-v2-1
OPENOCD_TARGET=stm32f7x
DEFS+= -DSTM32F767xx

DEBUG_FLAGS=
WARN_ERROR_FLAGS = -Wall -Wextra -Wdouble-promotion -Wshadow -Wformat-truncation -Wundef -fno-common -Wconversion
STACK_INFO_FLAGS = -fstack-usage 
MIN_SIZE_FLAGS =  -Os  
COMMON_FLAGS = -ffunction-sections -fdata-sections

CXXFLAGS = $(WARN_ERROR_FLAGS) $(STACK_INFO_FLAGS) $(COMMON_FLAGS) $(DEBUG_FLAGS) -std=c++11 -fno-exceptions -fno-rtti
CFLAGS 	 = $(WARN_ERROR_FLAGS) $(STACK_INFO_FLAGS) $(COMMON_FLAGS) $(DEBUG_FLAGS) -std=c99

MCFLAGS =-mcpu=cortex-m7 -mthumb -mlittle-endian -mfloat-abi=hard -mfpu=fpv5-sp-d16

# Linker flags
LDFLAGS = -Wl,--gc-sections --static -Wl,-Map=bin/$(PROJECT).map,--cref 
LDFLAGS += --specs=nano.specs
LDFLAGS += -T util/linker/$(LDSCRIPT) $(MCFLAGS) 

# GNU ARM Embedded Toolchain
CC=arm-none-eabi-gcc
CXX=arm-none-eabi-g++
LD=arm-none-eabi-ld
AR=arm-none-eabi-ar
AS=arm-none-eabi-as
CP=arm-none-eabi-objcopy
OD=arm-none-eabi-objdump
NM=arm-none-eabi-nm
SIZE=arm-none-eabi-size
A2L=arm-none-eabi-addr2line

# Find source files
ASOURCES=$(LIBDIR)/CMSIS/startup/$(STARTUP)
CSOURCES=$(shell find -L $(SRCDIR) $(LIBDIR) -name '*.c' 2> /dev/null)
CPPSOURCES=$(shell find -L $(SRCDIR) $(LIBDIR) -name '*.cpp' 2> /dev/null)

# Find header directories
INC=$(shell find -L $(INCDIR) -name '*.h' -exec dirname {} \; | uniq) 
INC+=$(shell find -L $(INCDIR) -name '*.hpp' -exec dirname {} \; | uniq)
INCLUDES=$(INC:%=-I%)

CFLAGS += -c $(MCFLAGS) $(DEFS) $(INCLUDES)
CXXFLAGS += -c $(MCFLAGS) $(DEFS) $(INCLUDES)

AOBJECTS = $(patsubst %,obj/%,$(ASOURCES))
COBJECTS = $(patsubst %,obj/%,$(CSOURCES))
CPPOBJECTS = $(patsubst %,obj/%,$(CPPSOURCES))

OBJECTS=$(AOBJECTS:%.s=%.o) $(COBJECTS:%.c=%.o) $(CPPOBJECTS:%.cpp=%.o)

# Define output files ELF & IHEX
BINELF=$(PROJECT).elf
BINHEX=$(PROJECT).hex

# Build Rules
.PHONY: targets all release debug clean flash erase reference

targets: CURRDIR=
targets: referenceCPP cppStaticClass cppConcreteClass cppPolyClass cppCRTPClass
	@./scripts/evaluateSizes.sh  \
	"Empty CPP Program" $(REFERENCEDIRCPP)$(BINDIR)/$(PROJECT).elf \
	"UART Driver as fully static CPP classes" $(CPPSTATICCLASS)$(BINDIR)/$(PROJECT).elf \
	"UART Driver as only concrete CPP classes" $(CPPCONCRETECLASS)$(BINDIR)/$(PROJECT).elf \
	"UART Driver as polymorphic CPP class" $(CPPPOLYCLASS)$(BINDIR)/$(PROJECT).elf \
	"UART Driver as CRTP CPP class" $(CPPCRPTCLASS)$(BINDIR)/$(PROJECT).elf

analyse:
	@./scripts/compileAll.sh

referenceCPP: CURRDIR=$(REFERENCEDIRCPP)
referenceCPP: PROJECT=$(REFERENCEBINCPP)
referenceCPP: 
	@echo -e "\033[0;34mBuilding: Minimum reference program (CPP) \033[0m"
	@make all --no-print-directory -C $(REFERENCEDIRCPP)

cppStaticClass: CURRDIR=$(CPPSTATICCLASS)
cppStaticClass: 
	@echo -e "\033[0;34mBuilding: Fully static CPP classes\033[0m"
	@make all --no-print-directory -C $(CPPSTATICCLASS)

cppConcreteClass: CURRDIR=$(CPPCONCRETECLASS)
cppConcreteClass: 
	@echo -e "\033[0;34mBuilding: Fully concrete CPP classes\033[0m"
	@make all --no-print-directory -C $(CPPCONCRETECLASS)

cppPolyClass: CURRDIR=$(CPPPOLYCLASS)
cppPolyClass: 
	@echo -e "\033[0;34mBuilding: USART polymorphic class\033[0m"
	@make all --no-print-directory -C $(CPPPOLYCLASS)

cppCRTPClass: CURRDIR=$(CPPCRPTCLASS)
cppCRTPClass: 
	@echo -e "\033[0;34mBuilding: USART CRPT class\033[0m"
	@make all --no-print-directory -C $(CPPCRPTCLASS)

clean: 
	@rm -rf $(REFERENCEDIRCPP)/$(OBJDIR) $(REFERENCEDIRCPP)/$(BINDIR)
	@rm -rf $(CPPSTATICCLASS)/$(OBJDIR) $(CPPSTATICCLASS)/$(BINDIR)
	@rm -rf $(CPPCONCRETECLASS)/$(OBJDIR) $(CPPCONCRETECLASS)/$(BINDIR)
	@rm -rf $(CPPPOLYCLASS)/$(OBJDIR) $(CPPPOLYCLASS)/$(BINDIR)
	@rm -rf $(CPPCRPTCLASS)/$(OBJDIR) $(CPPCRPTCLASS)/$(BINDIR)

all: release

release: $(BINDIR)/$(BINHEX)

$(BINDIR)/$(BINHEX): $(BINDIR)/$(BINELF)
	@$(CP) -O ihex $< $@

$(BINDIR)/$(BINELF): $(OBJECTS)
	@mkdir -p $(BINDIR)
	@$(CXX) $(OBJECTS) $(LDFLAGS) -o $@

$(OBJDIR)/%.o: %.cpp
	@mkdir -p $(dir $@)
	@$(CXX) $(CXXFLAGS) $< -o $@

$(OBJDIR)/%.o: %.c
	@mkdir -p $(dir $@)
	@$(CC) $(CFLAGS) $< -o $@

$(OBJDIR)/%.o: %.s
	@mkdir -p $(dir $@)
	@$(CC) $(CFLAGS) $< -o $@

flash: CURRDIR=$(TARGET)
flash: 
	@echo -e "\n\033[0;32m[Flashing]\033[0m"
	@openocd -f interface/$(OPENOCD_INTERFACE).cfg \
		-f target/$(OPENOCD_TARGET).cfg \
        -c "program $(BINDIR)/$(PROJECT).elf verify" \
		-c "reset" \
        -c "exit"
erase:
	@echo -e "\n\033[0;32m[Erasing]\033[0m"
	@openocd -f interface/$(OPENOCD_INTERFACE).cfg \
		-f target/$(OPENOCD_TARGET).cfg \
		-c "init" \
		-c "halt" \
		-c "$(OPENOCD_TARGET) mass_erase 0" \
        -c "exit"

print-%  : ; @echo $* = $($*)

rebase:
	@git rebase master oneFunction
	@git rebase master twoFunctions
	@git rebase master threeFunctions
	@git rebase master fourFunctions
	@git rebase master fiveFunctions
	@git rebase master sixFunctions
