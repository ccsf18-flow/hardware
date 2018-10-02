# G-Code targets.
.PHONY: gcode
gcode: ${GCODE}

define GCODE_RULE
$(call GCODE_NAME_FOR_STL,$(1)): $(1)
	@mkdir -p $$(dir $$(@))
	@echo Slicing: $${<} with profile $${PROFILE}
	@slic3r-prusa3d --print-center=$${PRINT_CENTER} \
	  --nozzle-diameter=$${NOZZLE} \
	  --threads=$${THREADS} \
	  --load=slic3r_profiles/filament/$${FILAMENT} \
	  --load=slic3r_profiles/print/$${PROFILE} \
	  --load=slic3r_profiles/printer/$${PRINTER} \
	  --output=$${@} \
	  $${<}

gcode : $(call GCODE_NAME_FOR_STL,$(1))

endef

# Slice the STL files into G-code
$(foreach stl, \
  $(STLS), \
  $(eval $(call GCODE_RULE,$(stl))))
