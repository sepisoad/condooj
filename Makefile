.PHONY: clean All

All:
	@echo "----------Building project:[ sdl2_opengl3_v6 - Debug ]----------"
	@cd "sdl2_opengl3_v6" && $(MAKE) -f  "sdl2_opengl3_v6.mk"
clean:
	@echo "----------Cleaning project:[ sdl2_opengl3_v6 - Debug ]----------"
	@cd "sdl2_opengl3_v6" && $(MAKE) -f  "sdl2_opengl3_v6.mk" clean
