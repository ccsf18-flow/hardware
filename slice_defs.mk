# slic3r config
FILAMENT ?= H200-B60
BASE_PROFILE ?= coarse1
PRINTER ?= E3
NOZZLE ?= 0.4
PRINT_CENTER ?= 110,110
BASE_PROFILE_CENTER ?= 110,110
PROFILE ?= $(BASE_PROFILE)

# Find STL files if not already specified.
STLS ?= $(shell find . -name "*.stl" | sort)
ifeq ($(STLS),)
  error "Cannot slice with no specified STL"
endif

## Output Configuration:
# Directory structure for the output gcode.
GCODE_PATH = build/${PRINTER}-${NOZZLE}-${FILAMENT}
# Add suffix to base .stl
GCODE_NAME =-${PROFILE}

# Generates a gcode name from a (list of) stls
define GCODE_NAME_FOR_STL =
  $(patsubst %.stl,$(GCODE_PATH)/%$(GCODE_NAME).gcode,$(1))
endef

# Determine the number of threads to use.
THREADS?=$(shell grep -c ^processor /proc/cpuinfo)
