STL = \
  module/module.stl

all : $(STL) gcode

module/module.stl : module/module.scad
	openscad -o $@ $<

include slice.mk

.PHONY: all

