PREFIX ?= /usr/local
BINDIR = $(PREFIX)/bin

.PHONY: help install uninstall

help:
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@echo "  install          Install the application."
	@echo "  uninstall        Uninstall the application."
	@echo ""

install:
	mkdir -p $(BINDIR)
	install -m 755 namaskar.sh $(BINDIR)/namaskar

uninstall:
	rm -f $(BINDIR)/namaskar
