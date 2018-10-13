STLS = \
  tools/sander.stl \
  module/bottom.stl \
  module/top.stl \
  water_block/base.stl \
  water_block/top.stl \
  tube_parts/hatch_gate.stl \
  tube_parts/hatch_servo_gear.stl \
  tube_parts/hatch_body.stl

all : $(STLS) gcode

stl : $(STLS)

$(STLS) : defs.scad

water_block/water_block.scad :: defs.scad servo.scad

water_block/top.scad :: water_block/water_block.scad
	touch $@

water_block/base.scad :: water_block/water_block.scad
	touch $@

module/module.scad :: defs.scad
	touch $@

module/top.scad :: module/module.scad
	touch $@

module/bottom.scad :: module/module.scad
	touch $@

tube_parts/hatch_body.scad :: tube_parts/hatch.scad
	touch $@

tube_parts/hatch_gate.scad :: tube_parts/hatch.scad
	touch $@

tube_parts/hatch_servo_gear.scad :: tube_parts/hatch.scad
	touch $@

%.stl: %.scad
	openscad -o $@ $<

include slice_defs.mk

include slice.mk

# $(call GCODE_NAME_FOR_STL,tube_parts/variable_flow.stl): PROFILE=coarse5_support
# $(call GCODE_NAME_FOR_STL,tube_parts/selective_flow_bottom.stl): PROFILE=coarse1_support
$(call GCODE_NAME_FOR_STL,tube_parts/hatch_gate.stl): PROFILE=coarse1_support
$(call GCODE_NAME_FOR_STL,tube_parts/hatch_body.stl): PROFILE=coarse1_internal_support

.PHONY: all stl

