STLS = \
  module/module.stl \
  tools/sander.stl \
  water_block/base.stl \
  water_block/top.stl \
  tube_parts/sluice_gate.stl \
  tube_parts/selective_flow_top.stl \
  tube_parts/selective_flow_bottom.stl

all : $(STLS) gcode

stl : $(STLS)

$(STLS) : defs.scad

water_block/water_block.scad :: defs.scad servo.scad

water_block/top.scad :: water_block/water_block.scad
	touch $@

water_block/base.scad :: water_block/water_block.scad
	touch $@

module/module.scad :: defs.scad

%.stl: %.scad
	openscad -o $@ $<

include slice_defs.mk

include slice.mk

# $(call GCODE_NAME_FOR_STL,tube_parts/variable_flow.stl): PROFILE=coarse5_support
$(call GCODE_NAME_FOR_STL,tube_parts/selective_flow_bottom.stl): PROFILE=coarse1_support

.PHONY: all stl

