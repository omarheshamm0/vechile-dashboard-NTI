# Vehicle Dashboard build entry point.
# Run make from this directory to build the AVR firmware.

.DEFAULT_GOAL := all

.PHONY: all clean

all:
	@$(MAKE) -C "Drivers_codes" all

clean:
	@$(MAKE) -C "Drivers_codes" clean
