CC          := gcc
CFLAGS	    += -O2 -lbz2 -Wall

PREFIX	    ?= /usr/local
INSTALL_PRG ?= ${INSTALL} -c -s -m 555
INSTALL_MAN ?= ${INSTALL} -c -m 444

#SOURCES := $(wildcard *.c)
#OBJECTS := $(SOURCES:.c=.o)

DIFF_SRCS   := bsdiff.c bsio.c utils.c
DIFF_OBJS   := $(DIFF_SRCS:.c=.o)
PATCH_SRCS  := bspatch.c bsio.c utils.c
PATCH_OBJS  := $(PATCH_SRCS:.c=.o)

all:		bsdiff bspatch

bsdiff:		$(DIFF_SRCS)

bspatch:	$(PATCH_SRCS)

#%.c: %.c
#	$(CC) -c $(CFLAGS) $< -o $@

clean:
	rm -f bsdiff bspatch tests/bin.patch tests/bin.patched

test:
	./bsdiff tests/bin1 tests/bin2 tests/bin.patch
	./bspatch tests/bin1 tests/bin.patched tests/bin.patch
	diff -s tests/bin2 tests/bin.patched
	md5sum tests/bin2
	md5sum tests/bin.patched

install:
	${INSTALL_PRG} bsdiff bspatch ${PREFIX}/bin
	${INSTALL_MAN} bsdiff.1 bspatch.1 ${PREFIX}/man/man1

