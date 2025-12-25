# Makefile for Coherent Shell Port
# Compatible with GNU Make and BSD Make

CC?= 		 gcc
CFLAGS+= 	-O2 -Wall -Wno-pointer-sign -I. -DDIRECTORY_STACK=1
YACC?= 		 yacc

VERSION?= 	 "V4.2.2"

OBJ= 	 alloc.o eval.o exec1.o exec2.o exec3.o extern.o \
	 glob.o lex.o main.o tab.o trap.o var.o parse.o buildobj.o io.o

SRCS=	 sh.h sh_port.h parse.y alloc.c eval.c exec1.c exec2.c exec3.c \
	 extern.c glob.c lex.c main.c tab.c trap.c var.c buildobj.c io.c

all: sh printf

sh: $(OBJ)
	$(CC) $(CFLAGS) -o sh $(OBJ) $(LDFLAGS)

printf: printf.o
	$(CC) $(CFLAGS) -o printf printf.o $(LDFLAGS)

parse.c: parse.y
	$(YACC) -d parse.y
	mv y.tab.c parse.c

parse.o: parse.c sh.h sh_port.h

# Dependencies
alloc.o:	sh.h sh_port.h alloc.c
eval.o:		sh.h sh_port.h eval.c
exec1.o:	sh.h sh_port.h exec1.c
exec2.o:	sh.h sh_port.h exec2.c
exec3.o:	sh.h sh_port.h exec3.c
extern.o:	sh.h sh_port.h extern.c
glob.o:		sh.h sh_port.h glob.c
lex.o:		sh.h sh_port.h lex.c parse.o
main.o:		sh.h sh_port.h main.c
tab.o:		sh.h sh_port.h tab.c
trap.o:		sh.h sh_port.h trap.c
var.o:		sh.h sh_port.h var.c
	$(CC) $(CFLAGS) -c var.c
buildobj.o:	sh.h sh_port.h buildobj.c
io.o:		sh.h sh_port.h shellio.h io.c
printf.o:	sh_port.h printf.c

clean:
	rm -f $(OBJ) sh printf y.tab.h parse.c printf.o y.tab.c
