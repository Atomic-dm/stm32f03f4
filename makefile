
# Определяем общие настройки проекта
# Имя программы:
TARGET = armf



CHIP = STM32F030x6


# Имя файла скрипта для линковщика:
LD_SCRIPT = STM32F030F4Px_FLASH.ld



# Частота иточника внешнего тактирования микроконтроллера:
HSE_VALUE = 8000000

# Ядро микроконтроллера. Передается как флаг компилятору в виде "-mcpu=$(MCU)":
MCU = cortex-m0

STONE = STM32F030F4

# Директивы препроцессора:
DEFS = -D$(CHIP)
DEFS += -DHSE_VALUE=$(HSE_VALUE)
DEFS += -DUSE_STDPERIPH_DRIVER
#DEFS += -DUSE_FULL_ASSERT
#DEFS += -DVER_MAJOR=$(VER_MAJOR)
#DEFS += -DVER_MINOR=$(VER_MINOR)


# Определеяем набор програм
# Для компиляции .c файлов:
CC = arm-none-eabi-gcc

# Для компиляции .cpp файлов:
CPP = arm-none-eabi-g++

# Для компиляции .s файлов:
AS = arm-none-eabi-gcc
#AS = arm-none-eabi-as

# Линковщик:
LD = arm-none-eabi-gcc

# Для копирования содержимого объектного файла в другой объектный файл:
OBJCOPY = arm-none-eabi-objcopy

# Для отображения информации о объектном файле:
OBJDUMP = arm-none-eabi-objdump

# Для подсчёта размера объектного файла:
SIZE = arm-none-eabi-size -d

# Для загрузки прошивки в микроконтроллер:
#FLASHER = ST-LINK_CLI
#FLASHER = openocd
FLASHER = jlink.exe
#FLASHER = st-flash
#FLASHER = stm32flash

JLINK_PARAMS_DEBUG = jlinkgdbserver.exe        
# запрос target remote localhost:2331
JLINK_PARAMS_DEBUG += -select USB
JLINK_PARAMS_DEBUG += -device $(STONE) 
JLINK_PARAMS_DEBUG += -if SWD
JLINK_PARAMS_DEBUG += -speed 1000 
JLINK_PARAMS_DEBUG += -noir

JLINK_OZONE = Ozone.exe ozone.jdebug

# Настройка openocd для работы с интерфейсом и контроллером:
OPENOCD_PARAMS = -c "source [find interface/stlink-v2.cfg]"
OPENOCD_PARAMS += -c "transport select hla_swd"
OPENOCD_PARAMS += -c "source [find target/stm32f0x.cfg]"

# Настройка openocd для прошивки контроллера:
OPENOCD_PARAMS_LOAD = $(OPENOCD_PARAMS)
OPENOCD_PARAMS_LOAD += -c "program $(ELF)"
#OPENOCD_PARAMS_LOAD += -c "flash write_image $(ELF)"
OPENOCD_PARAMS_LOAD += -c "verify_image $(ELF)"
OPENOCD_PARAMS_LOAD += -c "reset run"
OPENOCD_PARAMS_LOAD += -c "exit"

#настройка jlink для прошивки контроллера
JLINK_PARAMS_LOAD =  -device STM32F030F4 
JLINK_PARAMS_LOAD += -if SWD 
JLINK_PARAMS_LOAD += -speed 4000 
JLINK_PARAMS_LOAD += -commanderScript test.jlink


# Настройка openocd для перезагрузки контроллера:
OPENOCD_PARAMS_RESET = $(OPENOCD_PARAMS)
OPENOCD_PARAMS_RESET += -c "reset run"
OPENOCD_PARAMS_RESET += -c "shutdown"
OPENOCD_PARAMS_RESET += -c "exit"

# Настройки openocd для отладки:
OPENOCD_PARAMS_DEBUG = $(OPENOCD_PARAMS)
OPENOCD_PARAMS_DEBUG += -c "gdb_port 3333"
OPENOCD_PARAMS_DEBUG += -c "debug_level 2"
OPENOCD_PARAMS_DEBUG += -c "set WORKAREASIZE 0x2000"
OPENOCD_PARAMS_DEBUG += -c "reset_config srst_only"


# Определение порядка расположения файлов и папок
# Определеяем корневую папку проекта:
BASE = .

# Список папок с исходными файлами проекта:
SRCDIR = $(BASE)
SRCDIR += $(BASE)\CMSIS
SRCDIR += $(BASE)\StdPeriphLib
SRCDIR += $(BASE)\StdPeriphLib\inc
SRCDIR += $(BASE)\StdPeriphLib\src
SRCDIR += $(BASE)\user-code\inc
SRCDIR += $(BASE)\user-code\src
SRCDIR += $(BASE)\FatFs
SRCDIR += $(BASE)\Startup


# Формируем список папок с исходными файлами проекта:
INCDIR = $(patsubst %,-I "%",$(SRCDIR))

# Определяем папку для объектных файлов:
OBJDIR = $(BASE)/out/obj

# Определяем папку для файлов прошивки:
EXEDIR = $(BASE)/out/hex

# Определяем папку для файлов листинга:
LSTDIR = $(BASE)/out/lst

# Определяем расположение файлов .hex:
HEX = $(EXEDIR)/$(TARGET).hex

# Определяем расположение файлов .bin:
BIN = $(EXEDIR)/$(TARGET).bin

# Определяем расположение файлов .elf:
ELF = $(EXEDIR)/$(TARGET).elf

# Определяем расположение файлов .map:
MAP = $(LSTDIR)/$(TARGET).map

# Определяем расположение файлов .elf:
LSS = $(LSTDIR)/$(TARGET).lss

# Определяем перечень объектных файлов, которые будут передаваться линковщику:
#CPP_SRCS = $(wildcard $(addsuffix /*.cpp,$(SRCDIR)))
#C_SRCS = $(wildcard $(addsuffix /*.c,$(SRCDIR)))
#AS_SRCS = $(wildcard $(addsuffix /*.s,$(SRCDIR)))
#C_OBJS = $(patsubst %.c,%.o,$(C_SRCS))
#CPP_OBJS = $(patsubst %.cpp,%.o,$(CPP_SRCS))
#AS_OBJS = $(patsubst %.s,%.o,$(AS_SRCS))
#OBJS = $(patsubst %,$(OBJDIR)/%,$(C_OBJS) $(CPP_OBJS) $(AS_OBJS))

CSRC = $(wildcard $(addsuffix /*.c,$(SRCDIR)))
CPPSRC = $(wildcard $(addsuffix /*.cpp,$(SRCDIR)))
ASRC = $(wildcard $(addsuffix /*.s,$(SRCDIR)))
OBJS = $(addprefix $(OBJDIR)/,$(notdir $(CSRC:.c=.o) $(CPPSRC:.cpp=.o) $(ASRC:.s=.o) ))


# Определеяем флаги для компиляции и линковки
# Общие флаги

# Название ядра:
FLAGS = -mcpu=$(MCU)

# Система команд ядра микроконтроллера:
FLAGS += -mthumb

# Директивы препроцессора:
FLAGS += $(DEFS)

# Директории в которых находятся дополнительные исходные файлы проекта 
# (сюда передается в виде "-I ."):
FLAGS += $(INCDIR)

# "-Wa" - передает все последующие флаги в "arm-none-eabi-as"
# "-adhlns" - флаг, для созданя ассемблерного листинга
FLAGS += -Wa,-adhlns=$(addprefix $(LSTDIR)/, $(notdir $(addsuffix .lst,$(basename $<))))

# Информация о зависимостях записывается в файл, 
# получающийся при замене ".c" на ".d" на концах имен входных файлов:
FLAGS += -MD


# Флаги для *.c файлов:

# Включаем сюда общие флаги тоже:
CFLAGS = $(FLAGS)

# Общий уровень оптимизации:
CFLAGS += -O1

# Включаем отладочную информацию в объектный файл для GDB 
# (это позволит отладчику GDB, дать подробную информацию о процессе отладки):
CFLAGS += -g -gdwarf-2

# Указываем gcc использовать каналы в памяти вместо временных файлов для 
# обмена данными межtarget remote localhost:3333ду разными стадиями компиляции:
#CFLAGS += -pipe

# Разбиваем функции и данные в две разные секции:
CFLAGS += -ffunction-sections -fdata-sections

# Включаем вывод дополнительных предупреждений при компиляции проекта:
CFLAGS += -Wall -Wextra -Wundef -Wcast-align -Winline

# Флаги для математического ядра микроконтроллера:
#CFLAGS += -mfpu=fpv4-sp-d16
#CFLAGS += -mfloat-abi=hard

# Флаги для *.cpp файлов:

# Включаем сюда общие флаги, и флаги для *.c файлов:
CPPFLAGS = $(CFLAGS)

# Включаем стандарт Си++11 с расширениями GNU:
CPPFLAGS += -std=gnu++0x

# Отключаем исключения:
CPPFLAGS += -fno-exceptions

# Флаг для компиляции С++ без runtime type information:
CPPFLAGS += -fno-rtti

# Заменять любой неквалифицированный тип 
# битовых полей (unqualified bitfield type) на беззнаковый (unsigned):
CPPFLAGS += -funsigned-bitfields

# Выделям перечисленному типу (enum) только такое количество байт, 
# сколько требуется для объявленного:
CPPFLAGS += -fshort-enums

# Флаги для *.s файлов:
AFLAGS = $(CFLAGS)

# Для компиляции ассемблер-файлов использовать arm-none-eabi-gcc:
AFLAGS += -x assembler-with-cpp

# Флаги для линовщика:

# Название ядра:
LD_FLAGS = -mcpu=$(MCU)

# Система команд ядра микроконтроллера:
LD_FLAGS += -mthumb

# "-Wl" - передает все последующие флаги линковщику,
# "-Map" - флаг, для создания файла .map,
# "--cref" - для генерации таблицы перекрестных ссылок
LD_FLAGS += -Wl,-Map="$(MAP)",--cref

# Удаляем неиспользуемые секции:
LD_FLAGS += -Wl,--gc-sections

#LD_FLAGS += -Wl,--start-group
#LD_FLAGS += -Wl,-lnosys

# для sprintf
#LD_FLAGS += -specs=nosys.specs -specs=nano.specs -u _printf_float  

# Имя файла скрипта для линковки:
LD_FLAGS += -T$(LD_SCRIPT)

# Не передавать в линковщик стандартный стартап файл от GCC:
LD_FLAGS += -nostartfiles


# Передаем компилятору все пути к папкам, содержащим .c, .cpp, .s файлы проекта:
vpath %.c $(SRCDIR)
vpath %.cpp $(SRCDIR)
vpath %.s $(SRCDIR)

.SILENT :

.PHONY: build all clean make_dirs mem_erase program reset debug

# Список целей при построении проекта (можно закомментировать не используемые):
all:
	@echo - building $(TARGET)...
	$(MAKE) $(ELF)
	$(MAKE) $(HEX)
	$(MAKE) $(BIN)
	$(MAKE) $(LSS)
	$(SIZE) $(ELF)
#akemm	$(MAKE) program
	@echo "Errors: none"
#   $(MAKE) program
#	$(MAKE) debug
#	$(MAKE) reset
#	$(MAKE) mem_erase

rebuild:
	@echo - rebuilding $(TARGET)...
	$(MAKE) clean
	$(MAKE) make_dirs
	$(MAKE) $(ELF)
	$(MAKE) $(HEX)
	$(MAKE) $(BIN)
	$(MAKE) $(LSS)
	$(SIZE) $(ELF)
	@echo "Errors: none"


clean:
	@echo - cleaning...
	($(OBJDIR):&(rd /s /q "$(OBJDIR)" 2> NUL))&
	($(LSTDIR):&(rd /s /q "$(LSTDIR)" 2> NUL))&
	($(EXEDIR):&(rd /s /q "$(EXEDIR)" 2> NUL))&

make_dirs:
	@echo - making dirs...
	($(OBJDIR):&(mkdir "$(OBJDIR)" 2> NUL))&
	($(LSTDIR):&(mkdir "$(LSTDIR)" 2> NUL))&
	($(EXEDIR):&(mkdir "$(EXEDIR)" 2> NUL))&

mem_erase:
	@echo - erasing memory...
ifeq ($(FLASHER),ST-LINK_CLI)
	$(FLASHER) -c swd -me
endif

program:
	@echo - programming with $(FLASHER)...
ifeq ($(FLASHER),openocd)
	$(FLASHER) $(OPENOCD_PARAMS_LOAD)
endif
ifeq ($(FLASHER),ST-LINK_CLI)
# "-c" - установить свзяь, 
# "swd" - использовать SWD интерфейс, 
# "-me" - очистить всю память, 
# "-p" - загрузить прошивку в мк, 
# "-v" - произвести верификацию прошивки, 
# "-rst" - перезагрузить мк, 
# "-run" - запустить мк
	$(FLASHER) -c swd -me -p "$(HEX)" -v -rst -run
endif
ifeq ($(FLASHER),jlink.exe)
	$(FLASHER) $(JLINK_PARAMS_LOAD)
endif

reset:
	@echo - resetting device...
ifeq ($(FLASHER),openocd)
	$(FLASHER) $(OPENOCD_PARAMS_RESET)
endif
ifeq ($(FLASHER),ST-LINK_CLI)
	$(FLASHER) -Rst
endif

debug:	
ifeq ($(FLASHER),openocd)
	@echo - openocd server is running...	
	$(FLASHER) $(OPENOCD_PARAMS_DEBUG)
endif
ifeq ($(FLASHER),jlink.exe)
	@echo - jlink gbdserver is running...	
	$(JLINK_PARAMS_DEBUG)		
endif

ozone:
	@echo - OZONE is running...
	$(JLINK_OZONE)	


build:
	$(MAmakeKE) all


$(ELF): $(OBJS) makefile
	@echo - linking...
# "-o" - флаг, после которого задается имя файла, который будет получен
	$(LD) $(OBJS) $(LD_FLAGS) -o $(ELF)

$(HEX): $(ELF) makefile
	@echo - making hex...
	$(OBJCOPY) -O ihex $(ELF) $(HEX)

$(BIN): $(ELF) makefile
	@echo - making bin...
	$(OBJCOPY) -O binary $(ELF) $(BIN)

$(LSS): $(ELF) makefile
	@echo - making asm-lst...
	$(OBJDUMP) -dC $(ELF) > $(LSS)


$(OBJDIR)/%.o: %.cpp makefile
	@echo - compiling $<...
# "-o" - флаг, после которого задается имя файла, который будет получен
# "-c" - скомпилировать исходные файлы без линковки
	$(CPP) -c $(CPPFLAGS) -o $@ $<

$(OBJDIR)/%.o: %.c makefile
	@echo - compiling $<...
	$(CC) -c $(CFLAGS) -o $@ $<

$(OBJDIR)/%.o: %.s makefile
	@echo - assembling $<...
	$(AS) -c $(AFLAGS) -o $@ $<





#program:
#ifeq ($(FLASHER),openocd)
#	$(FLASHER) $(OPENOCD_PARAMS_LOAD)
#endif
#ifeq ($(FLASHER),st-flash)
#	$(FLASHER) write $(BIN) 0x08000000
#endif
#ifeq ($(FLASHER),stm32flash)
#	$(FLASHER) -b 115200 -w $(HEX) -v -g 0x0 /dev/ttyS0
##	$(FLASHER) -b 115200 -w $(HEX) -v -g 0x0 COM1
#endif
#ifeq ($(FLASHER),ST-LINK_CLI)
#	$(FLASHER) -Q -P $(HEX) -V $(HEX) -Run
#endif
#
#reset:
#	@echo Resetting device
#ifeq ($(FLASHER),ST-LINK_CLI)
#	$(FLASHER) -Q -Rst
#endif
#ifeq ($(FLASHER),openocd)
#	$(FLASHER) $(OPENOCD_PARAMS_RESET)
#endif
