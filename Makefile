INSTALLDIR=/usr/local/lib/lua/5.2/hashids

UNAME := $(shell uname -s)

all:
ifeq ($(UNAME),Darwin)
	@echo building for OS X
	gcc -bundle -undefined dynamic_lookup -I/usr/local/include/ -o src/clib.so src/clib.c
else
	@echo building for Linux
	gcc -Wall -shared -fPIC -I/usr/include/lua5.2 -o src/clib.so src/clib.c
endif

install:
	@echo installing lib
	@mkdir -p $(INSTALLDIR)
	cp src/init.lua $(INSTALLDIR)
	cp src/clib.so $(INSTALLDIR)

clean:
	@echo Cleaning...
	@rm -f src/clib.so
