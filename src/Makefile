# If you change the build options, don't forget to do a 'make clean' before
CHECK=
ASSERT=

##############################################################################

FLASH_OS_BSS_START=0x5B00

DEFS=
ifeq	($(ASSERT),1)
DEFS+= -WA,-vWANT_ASSERT
endif

##############################################################################

LDFLAGS=--cut-ranges --optimize-code --remove-unused --optimize-relocs --merge-constants
CFLAGS=-Os -fomit-frame-pointer -Wall -W -fno-builtin
INCLUDES=-I. -Ic

CC=tigcc $(LDFLAGS)
AS=tigcc -c $(LDFLAGS) -WA,-ic $(DEFS)
LD=ld-tigcc -v --flash-os --flash-os-bss-start=$(FLASH_OS_BSS_START) --outputbin $(LDFLAGS) $(TIGCC)/lib/flashos.a
MV=mv -f
CP=cp -f

##############################################################################

# Define the source files
ST1_ASM=Boot.asm Flash.asm System.asm ShellIO.asm Builtin.asm Link.asm Strings.asm Vat.asm Memstr.asm Heap.asm Graph.asm Misc.asm
TEXT_ASM=Bcd.asm Estack2.asm Script.asm Estack.asm Ints.asm Long.asm Vectors.asm Cert.asm Kernel.asm Process.asm Window.asm Dialog.asm Library.asm  Misc2.asm RomVoid.asm Strings.asm Bss.asm unpack.asm
SOURCE_ASM=PedroM.asm PedroM2.asm Bss.asm
SOURCE_C=c/files.c c/printf.c c/clipline.c c/bitmap.c c/qsort.c c/md5.c c/float.c c/ellipse.c c/side.c

SOURCE=$(patsubst %.c,%.asm,$(SOURCE_C))

OBJ89=$(patsubst %.asm,%.89.o,$(SOURCE_ASM)) $(patsubst %.c,%.89.o,$(SOURCE_C))
OBJ9x=$(patsubst %.asm,%.9x.o,$(SOURCE_ASM)) $(patsubst %.c,%.9x.o,$(SOURCE_C))
OBJV2=$(patsubst %.asm,%.v2.o,$(SOURCE_ASM)) $(patsubst %.c,%.v2.o,$(SOURCE_C))
OBJ89T=$(patsubst %.asm,%.89t.o,$(SOURCE_ASM)) $(patsubst %.c,%.89t.o,$(SOURCE_C))

##############################################################################

# Rules to build for different calculator
%.89.o: %.c
	$(CC) $(CFLAGS) $(INCLUDES) -DPEDROM -DTI89 -c $< -o $@
%.89.o: %.asm
	$(AS) -WA,-vTI89 $< -o $@
%.9x.o: %.asm
	$(AS) -WA,-vTI92P $< -o $@
%.9x.o: %.c
	$(CC) $(CFLAGS) $(INCLUDES) -DPEDROM -DTI92P -c $< -o $@
%.v2.o: %.asm
	$(AS) -WA,-vV200 $< -o $@
%.v2.o: %.c
	$(CC) $(CFLAGS) $(INCLUDES) -DPEDROM -DTI92P -c $< -o $@
%.89t.o: %.asm
	$(AS) -WA,-vTI89TI $< -o $@
%.89t.o: %.c
	$(CC) $(CFLAGS) $(INCLUDES) -DPEDROM -DTI89  -c $< -o $@

##############################################################################

# Define the default targets.
all: pedrom-89 pedrom-9x pedrom-89t pedrom-v200

# Define the targets which are always to be done.
.PHONY: version.h clean

# Define the dependency of PedroM.asm / PedroM2.asm
PedroM.asm: version.h $(ST1_ASM)
	@touch $@
PedroM2.asm: $(TEXT_ASM)
	@touch $@

# Generate the current time into an assembly file
version.h:
	echo " dc.b" \"`date -u +"[%Y%m%d %k:%M]"`\" > version.h

##############################################################################

# TIB rules
pedrom-89: $(OBJ89)
	$(LD) $^ -o PedroM 
	$(MV) PedroM-89.tib ..
pedrom-9x: $(OBJ9x)
	$(LD) $^ -o PedroM
	$(MV) PedroM-9x.tib ..
pedrom-89t: $(OBJ89T)
	$(LD) $^ -o PedroM
	$(MV) PedroM-89ti.tib .. && $(RM) PedroM-89.tib
pedrom-v200: $(OBJV2)
	$(LD) $^ -o PedroM
	$(MV) PedroM-v2.tib ..

# Clean up
clean:
	$(RM) c/*.asm c/*~ c/*.o version.h *.o *~ *.tib *.lst
