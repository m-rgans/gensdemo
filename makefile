
ASMBR=vasm
INCLUDES=-Ires/ -Ilib/

LISTING=LISTING.TXT
BINNAME=OUT.GEN

FLAGS=-chklabels -nocase -Dvasm=1 -DBuildGen=1 -Fbin

SRC=src/impl2.s

vpath %.s src

$(BINNAME) : main.s footer.s header.s vdpInterface.s
	cd src;\
	$(ASMBR) $< $(INCLUDES) $(FLAGS) -L ../$(LISTING) -o ../$(BINNAME)

clean:
	rm -f $(BINNAME)
	rm -f $(LISTING)
