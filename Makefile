UNAME := $(shell uname -s)

all:
	@mkdir lib
ifeq ($(UNAME),Darwin)
	@echo building for OS X
	gcc -bundle -undefined dynamic_lookup -I/usr/local/include/ -o lib/clib.so src/clib.c
else
	@echo building for Linux
	gcc -Wall -shared -fPIC -I/usr/include/lua5.1 -o lib/clib.so src/clib.c
endif
