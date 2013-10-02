DESTDIR=/usr

.PHONY: all

all: 
	@echo Building migcom...
	make -C bootstrap_cmds-60/migcom.tproj/
	@echo Building cctools...
	/bin/sh -c "cd cctools-836; ./configure --target=arm-apple-darwin11 --prefix=/; make CFLAGS=-I$(pwd)/include all"
	@echo Building kext-tools...
	make -C kext-tools/

install:
	@echo Installing mig and migcom...
	make -C bootstrap_cmds-60/migcom.tproj/ DESTDIR=$(DESTDIR) install
	@echo Installing cctools...
	make -C cctools-836/ DESTDIR=$(DESTDIR) install
	@echo Installing kext-tools
	make -C kext-tools/ DESTDIR=$(DESTDIR) install
	@echo Installing xcode stubs...
	@/bin/sh gen-stubs.sh $(DESTDIR)

compiler_rt:
	@echo Building compiler-rt
	make -C compiler-rt/ clang_darwin
	cp compiler-rt/clang_darwin/cc_kext/libcompiler_rt.a $(DESTDIR)/lib/libclang_rt.cc_kext.a

clean:
	@echo Cleaning migcom...
	make -C bootstrap_cmds-60/migcom.tproj/ clean
	@echo Cleaning cctools...
	make -C cctools-836/ distclean
	@echo Cleaning kext-tools...
	make -C kext-tools/ distclean
	@echo Installing prebuilt libclang_rt.cc_kext.a...
	install -d $(DESTDIR)/lib
	install -m 644 prebuilt/libclang_rt.cc_kext.a $(DESTDIR)/lib/libclang_rt.cc_kext.a
