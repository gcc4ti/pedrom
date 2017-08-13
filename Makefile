VERSION=0.83

# Make the tools, build the TIB, and sign them if there are any key to use.
all:
	cd src && make
	for i in *.tib ; do rabbitsign -r $$i ; done

clean:
	cd src && make clean
	rm -f *~
	rm -f *.tib *.9xu *.89u
	cd doc && rm -f *~
	cd example && make clean

dist: clean
	cd .. && 7zr a -mx9 '-xr!*.o' '-xr!.git' '-xr!*~' '-xr!*.7z'  '-xr!*.key' pedrom-$(VERSION).7z pedrom/ && mv pedrom-$(VERSION).7z pedrom
