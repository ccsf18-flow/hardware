STL = \
  module/module.stl \
  water_block/base.stl \
  water_block/top.stl \
  tube_parts/variable_flow_cap.stl \
  tube_parts/variable_flow.stl

all : $(STL) gcode

stl : $(STL)

$(STL) : defs.scad

water_block/water_block.scad :: defs.scad servo.scad

water_block/top.scad :: water_block/water_block.scad
	touch $@

water_block/base.scad :: water_block/water_block.scad
	touch $@

module/module.scad :: defs.scad

%.stl: %.scad
	openscad -o $@ $<


include slice.mk

.PHONY: all stl

