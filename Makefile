# Target name
TARGET	= irena
TESTS_DIR = ./unittests

# Compiler
CC	= g++

# Timer implementation
TIMER_CHRONO = n

# Compiler flags
CFLAGS += -Iinclude
CFLAGS += -I/usr/local/cuda/include
CFLAGS += -Isrc/cl
CFLAGS += -DDEFAULT_MAX_PREDICTION=2
CFLAGS += -DDEFAULT_KERNEL_SRC="\"kernel.cl\""
CFLAGS += -DDEFAULT_PREDICTION_METHOD=PREDICTION_METHOD_MSE
CFLAGS += -DDEFAULT_INTERPOLATION_SCALE=2
CFLAGS += -DDEFAULT_PROGRESS_BAR=true
CFLAGS += -DDEFAULT_PRINT_TIMERS=false
CFLAGS += -DDEFAULT_VERBOSE=0
CFLAGS += -DDEFAULT_Q=1
CFLAGS += -DDEFAULT_HUFFMAN_TYPE=HUFFMAN_TYPE_STATIC
CFLAGS += -DDEFAULT_DEVICE_TYPE=CL_DEVICE_TYPE_GPU
CFLAGS += -DVERSION="\""$(shell git describe)"\""
CFLAGS += -O3
CFLAGS += -Wall
# Enablde this flag if you want to call clFinish after every clEnqueueNDRangeKernel
#CFLAGS += -DCL_KERNEL_FINISH

# Linker flags
LDFLAGS	+= -L/usr/lib

# Libs
LIBS = -lOpenCL

# Source files
SRC += src/main.cpp
SRC += src/app.cpp
SRC += src/log.cpp
SRC += src/avlib.cpp
SRC += src/decoder.cpp
SRC += src/getopt.cpp
SRC += src/prediction.cpp
SRC += src/static_huffman.cpp
SRC += src/basic_decoder.cpp
SRC += src/getopt_long.cpp
SRC += src/quantizer.cpp
SRC += src/static_rlc.cpp
SRC += src/basic_encoder.cpp 
SRC += src/dynamic_huffman.cpp
SRC += src/image.cpp
SRC += src/rlc.cpp
SRC += src/rlc_factory.cpp
SRC += src/transform.cpp
SRC += src/bitstream.cpp
SRC += src/component.cpp
SRC += src/dynamic_rlc.cpp
SRC += src/sequence.cpp
SRC += src/utils.cpp
SRC += src/dct.cpp
SRC += src/encoder.cpp
SRC += src/mtimer.cpp
SRC += src/shift.cpp
SRC += src/zigzag.cpp
SRC += src/interpolation.cpp
SRC += src/psnr.cpp
SRC += src/cl_base.cpp
SRC += src/cl_encoder.cpp
SRC += src/cl_parallel_encoder.cpp
SRC += src/cl_merged_encoder.cpp
SRC += src/cl_policy.cpp
SRC += src/cl_component.cpp
SRC += src/cl_image.cpp
SRC += src/cl_quantizer.cpp
SRC += src/cl_dct.cpp
SRC += src/cl_kernel.cpp
SRC += src/cl_zigzag.cpp
SRC += src/cl_device.cpp
SRC += src/cl_platform.cpp
SRC += src/cl_device_info.cpp
SRC += src/cl_platform_info.cpp
SRC += src/cl_shift.cpp
SRC += src/cl_prediction.cpp
SRC += src/cl_host.cpp
SRC += src/cl_dctqzz.cpp
SRC += src/cl_interpolation.cpp
SRC += src/cl_timers.cpp

# OpenCL kernel source
CL_KERNEL = kernel.cl
CL_KERNEL_PATH = src/cl/$(CL_KERNEL)

ifeq ($(TIMER_CHRONO), y)
CFLAGS += -DUSE_TIMER_CHRONO
CFLAGS += -std=c++0x
else
CFLAGS += -DUSE_TIMER_REAL_TIME
SRC += src/getRealTime.cpp
LIBS += -lrt
endif

ifeq ($(DEBUG), 1)
CFLAGS += -g
CFLAGS += -DDEBUG
CFLAGS += -DCHECK_HUFFMAN
CFLAGS += -DIMAGE_CHECK_INDEX
CFLAGS += -DCOMPONENT_CHECK_INDEX
endif


# Objects
OBJ	= $(SRC:.cpp=.o)

default: $(TARGET)

.PHONY : debug all
debug:
	$(MAKE) default DEBUG=1

all: $(TARGET) tests

$(TARGET): $(OBJ) $(CL_KERNEL)
	$(CC) $(LDFLAGS) -o $(TARGET) $(OBJ) $(LIBS)

$(CL_KERNEL): $(CL_KERNEL_PATH)
	@echo Copying $(CL_KERNEL)
	@cp -vf $(CL_KERNEL_PATH) $(CL_KERNEL)

%.o : %.cpp
	$(CC) $(CFLAGS) -c $< -o $@

.PHONY : vim vim_clean
vim: 
	@echo Creating .vimrc file
	@ln -sfv scripts/.vimrc

vim_clean:
	@echo Removing .vimrc file
	@rm -rf .vimrc

.PHONY : tests tests_clean
tests:
	$(MAKE) -C $(TESTS_DIR)

tests_clean:
	$(MAKE) -C $(TESTS_DIR) clean

clean: tests_clean
	rm -rf $(TARGET) $(OBJ) $(CL_KERNEL)
