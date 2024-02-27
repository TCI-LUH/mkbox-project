SOURCE_DOCS_MAN1 := $(wildcard *.1.md)
SOURCE_DOCS_MAN8 := $(wildcard *.8.md)

EXPORTED_DOCS_MAN1=$(SOURCE_DOCS_MAN1:.1.md=.1.gz) 
EXPORTED_DOCS_MAN8=$(SOURCE_DOCS_MAN8:.8.md=.8.gz) 
EXPORTED_DOCS= $(EXPORTED_DOCS_MAN1) $(EXPORTED_DOCS_MAN8)

RM ?= /bin/rm

PREFIX ?= /usr/local/

PANDOC ?= pandoc
GZIP ?= gzip
CP ?= cp
MKDIR ?= mkdir

PANDOC_OPTIONS=--standalone -t man

%.gz : %.md
	$(PANDOC) $(PANDOC_OPTIONS)  $< | $(GZIP) > $@


.PHONY: all clean

all : $(EXPORTED_DOCS)

clean:
	- $(RM) $(EXPORTED_DOCS)

install:
	- $(MKDIR) -p "$(PREFIX)/share/man/man1"
	- $(CP) $(EXPORTED_DOCS_MAN1) "$(PREFIX)/share/man/man1"
	- $(MKDIR) -p "$(PREFIX)/share/man/man8"
	- $(CP) $(EXPORTED_DOCS_MAN8) "$(PREFIX)/share/man/man8"

uninstall:
	- $(RM) $(addprefix "$(PREFIX)/share/man/man1/", $(EXPORTED_DOCS_MAN1))
	- $(RM) $(addprefix "$(PREFIX)/share/man/man8/", $(EXPORTED_DOCS_MAN8))