STL = \
  module/module.stl \
  water_block/water_block.stl \
  water_block/base.stl \
  water_block/top.stl \

all : $(STL) gcode

stl : $(STL)

$(STL) : defs.scad

water_block/water_block.scad :: defs.scad servo.scad

module/module.scad :: defs.scad

%.stl: %.scad
	openscad -o $@ $<


include slice.mk

.PHONY: all stl

