.PHONY: clean All

All:
	@echo "----------Building project:[ condooj - Debug ]----------"
	@$(MAKE) -f  "condooj.mk"
clean:
	@echo "----------Cleaning project:[ condooj - Debug ]----------"
	@$(MAKE) -f  "condooj.mk" clean
