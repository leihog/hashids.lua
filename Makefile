UNAME := $(shell uname -s)

all:
ifeq ($(UNAME),Darwin)
	@echo building for OS X
	gcc -bundle -undefined dynamic_lookup -I/usr/local/include/ -o hashids/clib.so hashids/clib.c
else
	@echo building for Linux
	gcc -Wall -shared -fPIC -I/usr/include/lua5.1 -o hashids/clib.so hashids/clib.c
endif
