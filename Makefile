# Project name
PROJECT=base

# User defined global definitions
DEFS =

# Comparison targets
REFERENCEDIRCPP=minimumReferenceCPP
REFERENCEDIRC=minimumReferenceC
REFERENCEDIRC=minimumReferenceC
SINGLEFUNCTIONC=singleFunctionUARTC
SINGLEFUNCTIONCPP=singleFunctionUARTCPP
SINGLEFILEC=singleFileUARTC
SINGLEFILECPP=singleFileUARTCPP
CSTYLEMODULES=cStyleModulesUART
CPPSTATICCLASS=cppFullyStaticClassUART
CPPCONCRETECLASS=cppConcreteClassUART
CPPPOLYCLASS=cppPolymorphicClassUART

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
targets: referenceCPP referenceC singleFunctionUartC singleFunctionUartCPP singleFileUartC singleFileUartCPP cStyleModules cppStaticClass cppConcreteClass cppPolyClass
	@./scripts/evaluateSizes.sh  \
	"Empty reference C program" $(REFERENCEDIRC)$(BINDIR)/$(PROJECT).elf \
	"Empty reference CPP program" $(REFERENCEDIRCPP)$(BINDIR)/$(PROJECT).elf \
	"UART Driver in single C function" $(SINGLEFUNCTIONC)$(BINDIR)/$(PROJECT).elf \
	"UART Driver in single CPP function" $(SINGLEFUNCTIONCPP)$(BINDIR)/$(PROJECT).elf \
	"UART Driver in single C File with split functions" $(SINGLEFILEC)$(BINDIR)/$(PROJECT).elf \
	"UART Driver in single CPP File with split functions" $(SINGLEFILECPP)$(BINDIR)/$(PROJECT).elf \
	"UART Driver as C style modules" $(CSTYLEMODULES)$(BINDIR)/$(PROJECT).elf \
	"UART Driver as fully static CPP classes" $(CPPSTATICCLASS)$(BINDIR)/$(PROJECT).elf \
	"UART Driver as only concrete CPP classes" $(CPPCONCRETECLASS)$(BINDIR)/$(PROJECT).elf \
	"UART Driver as polymorphic CPP class" $(CPPPOLYCLASS)$(BINDIR)/$(PROJECT).elf

referenceCPP: CURRDIR=$(REFERENCEDIRCPP)
referenceCPP: PROJECT=$(REFERENCEBINCPP)
referenceCPP: 
	@echo -e "\033[0;34mMinimum reference program (CPP) \033[0m"
	@make all --no-print-directory -C $(REFERENCEDIRCPP)
	@echo "--------------------"

referenceC: CURRDIR=$(REFERENCEDIRC)
referenceC: PROJECT=$(REFERENCEBINC)
referenceC: 
	@echo -e "\033[0;34mMinimum reference program (C) \033[0m"
	@make all --no-print-directory -C $(REFERENCEDIRC)
	@echo "--------------------"

singleFunctionUartC: CURRDIR=$(SINGLEFUNCTIONC)
singleFunctionUartC: 
	@echo -e "\033[0;34mSingle funtion UART driver (C) \033[0m"
	@make all --no-print-directory -C $(SINGLEFUNCTIONC)
	@echo "--------------------"

singleFunctionUartCPP: CURRDIR=$(SINGLEFUNCTIONCPP)
singleFunctionUartCPP: 
	@echo -e "\033[0;34mSingle function UART driver (CPP) \033[0m"
	@make all --no-print-directory -C $(SINGLEFUNCTIONCPP)
	@echo "--------------------"

singleFileUartC: CURRDIR=$(SINGLEFILEC)
singleFileUartC: 
	@echo -e "\033[0;34mSingle file UART driver (C) \033[0m"
	@make all --no-print-directory -C $(SINGLEFILEC)
	@echo "--------------------"

singleFileUartCPP: CURRDIR=$(SINGLEFILECPP)
singleFileUartCPP: 
	@echo -e "\033[0;34mSingle file UART driver (CPP) \033[0m"
	@make all --no-print-directory -C $(SINGLEFILECPP)
	@echo "--------------------"

cStyleModules: CURRDIR=$(CSTYLEMODULES)
cStyleModules: 
	@echo -e "\033[0;34mC-Style module UART driver \033[0m"
	@make all --no-print-directory -C $(CSTYLEMODULES)
	@echo "--------------------"

cppStaticClass: CURRDIR=$(CPPSTATICCLASS)
cppStaticClass: 
	@echo -e "\033[0;34mFully static CPP classes\033[0m"
	@make all --no-print-directory -C $(CPPSTATICCLASS)
	@echo "--------------------"

cppConcreteClass: CURRDIR=$(CPPCONCRETECLASS)
cppConcreteClass: 
	@echo -e "\033[0;34mFully concrete CPP classes\033[0m"
	@make all --no-print-directory -C $(CPPCONCRETECLASS)
	@echo "--------------------"

cppPolyClass: CURRDIR=$(CPPPOLYCLASS)
cppPolyClass: 
	@echo -e "\033[0;34mUSART polymorphic class\033[0m"
	@make all --no-print-directory -C $(CPPPOLYCLASS)
	@echo "--------------------"

clean: 
	@rm -rf $(REFERENCEDIRCPP)/$(OBJDIR) $(REFERENCEDIRCPP)/$(BINDIR)
	@rm -rf $(REFERENCEDIRC)/$(OBJDIR) $(REFERENCEDIRC)/$(BINDIR)
	@rm -rf $(SINGLEFUNCTIONC)/$(OBJDIR) $(SINGLEFUNCTIONC)/$(BINDIR)
	@rm -rf $(SINGLEFUNCTIONCPP)/$(OBJDIR) $(SINGLEFUNCTIONCPP)/$(BINDIR)
	@rm -rf $(SINGLEFILEC)/$(OBJDIR) $(SINGLEFILEC)/$(BINDIR)
	@rm -rf $(SINGLEFILECPP)/$(OBJDIR) $(SINGLEFILECPP)/$(BINDIR)
	@rm -rf $(CSTYLEMODULES)/$(OBJDIR) $(CSTYLEMODULES)/$(BINDIR)
	@rm -rf $(CPPSTATICCLASS)/$(OBJDIR) $(CPPSTATICCLASS)/$(BINDIR)
	@rm -rf $(CPPCONCRETECLASS)/$(OBJDIR) $(CPCONCRETECLASS)/$(BINDIR)
	@rm -rf $(CPPPOLYCLASS)/$(OBJDIR) $(CPPPOLYCLASS)/$(BINDIR)

all: release

release: $(BINDIR)/$(BINHEX)

$(BINDIR)/$(BINHEX): $(BINDIR)/$(BINELF)
	@$(CP) -O ihex $< $@
	@echo -e "\033[0;32m [OK] \033[0m       \033[0;33m Converted:\033[0m" $<
	@echo -e "\n\033[0;32m[Binary Size]\033[0m"
	@$(SIZE) $(BINDIR)/$(BINELF)

$(BINDIR)/$(BINELF): $(OBJECTS)
	@mkdir -p $(BINDIR)
	@$(CXX) $(OBJECTS) $(LDFLAGS) -o $@
	@echo -e "\033[0;32m [OK] \033[0m       \033[0;33m Linked:\033[0m" $<

$(OBJDIR)/%.o: %.cpp
	@mkdir -p $(dir $@)
	@$(CXX) $(CXXFLAGS) $< -o $@
	@echo -e "\033[0;32m [OK] \033[0m       \033[0;33m Compiled:\033[0m" $<

$(OBJDIR)/%.o: %.c
	@mkdir -p $(dir $@)
	@$(CC) $(CFLAGS) $< -o $@
	@echo -e "\033[0;32m [OK] \033[0m       \033[0;33m Compiled:\033[0m" $<

$(OBJDIR)/%.o: %.s
	@echo -e "\033[0;32m[Compiling]\033[0m"
	@mkdir -p $(dir $@)
	@$(CC) $(CFLAGS) $< -o $@
	@echo -e "\033[0;32m [OK] \033[0m       \033[0;33m Assembled:\033[0m" $<

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

