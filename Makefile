PREFIX ?= /usr/local
BINDIR = $(PREFIX)/bin

.PHONY: install uninstall

install:
	mkdir -p $(BINDIR)
	install -m 755 namaskar.sh $(BINDIR)/namaskar

uninstall:
	rm -f $(BINDIR)/namaskar
