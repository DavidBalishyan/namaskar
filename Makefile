PREFIX ?= /usr/local
BINDIR  = $(PREFIX)/bin

# Colors
RESET   = \033[0m
BOLD    = \033[1m
BLUE    = \033[1;34m
GREEN   = \033[1;32m
RED     = \033[1;31m
YELLOW  = \033[1;33m
CYAN    = \033[1;36m

.PHONY: help install uninstall

help:
	@echo "$(BOLD)$(CYAN)Usage:$(RESET) make [target]"
	@echo ""
	@echo "$(BOLD)$(BLUE)Targets:$(RESET)"
	@echo "  $(GREEN)install$(RESET)          Install the application (interactive)."
	@echo "  $(RED)uninstall$(RESET)        Uninstall the application (auto-detect)."
	@echo ""
	@echo "  $(BOLD)$(YELLOW)NOTE:$(RESET) $(BOLD)sudo$(RESET) is required for /usr/local/bin"
	@echo ""


install:
	@echo "$(BOLD)$(CYAN)Choose installation directory:$(RESET)"
	@echo "  $(YELLOW)1)$(RESET) /usr/local/bin   $(RED)(requires sudo)$(RESET)"
	@echo "  $(YELLOW)2)$(RESET) ~/.local/bin"
	@echo "  $(YELLOW)3)$(RESET) ~/bin"
	@echo ""
	@read -p "Enter choice [1-3]: " choice; \
	if [ "$$choice" = "1" ]; then \
		BIN="/usr/local/bin"; \
		SUDO="sudo"; \
	elif [ "$$choice" = "2" ]; then \
		BIN="$$HOME/.local/bin"; \
		SUDO=""; \
	elif [ "$$choice" = "3" ]; then \
		BIN="$$HOME/bin"; \
		SUDO=""; \
	else \
		echo "$(RED)✖ Invalid choice$(RESET)"; \
		exit 1; \
	fi; \
	echo "$(GREEN)→ Installing to $$BIN$(RESET)"; \
	$$SUDO mkdir -p "$$BIN" || exit 1; \
	$$SUDO install -m 755 namaskar.sh "$$BIN/namaskar" || exit 1; \
	echo "$(GREEN)✔ Installed successfully to $$BIN$(RESET)"; \
	case ":$$PATH:" in \
		*:"$$BIN":*) ;; \
		*) echo "$(YELLOW)⚠ $$BIN is not in your PATH$(RESET)";; \
	esac



uninstall:
	@BIN="$$(which namaskar 2>/dev/null)"; \
	if [ -z "$$BIN" ]; then \
		echo "$(RED)✖ namaskar is not installed or not in PATH$(RESET)"; \
		exit 1; \
	fi; \
	echo "$(YELLOW)→ Found namaskar at $$BIN$(RESET)"; \
	rm -f "$$BIN"; \
	echo "$(GREEN)✔ Uninstalled namaskar$(RESET)"



