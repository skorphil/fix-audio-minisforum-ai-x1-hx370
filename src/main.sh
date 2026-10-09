# Ensure root privileges for system-level changes
if [[ $EUID -ne 0 && "$1" != "--help" && "$1" != "-h" ]]; then
   echo -e "${RED}${BOLD}Error:${NC} This script must be run as root."
   echo -e "Please try: ${CYAN}sudo $0${NC}"
   exit 1
fi

case "${1:-}" in
    --apply)
        # Internal flag used by systemd
        apply_fix
        ;;
    --install)
        check_hardware
        install_fix
        ;;
    --uninstall)
        uninstall_fix
        ;;
    --status)
        if is_installed; then
            echo "Installed"
        else
            echo "Not installed"
            exit 1
        fi
        ;;
    --help|-h)
        echo "Minisforum AI X1 Audio Fix Manager"
        echo ""
        echo "Usage:"
        echo "  sudo ./hx370-audio-fix.sh [option]"
        echo ""
        echo "Options:"
        echo "  (none)       Launch interactive TUI"
        echo "  --install    Install services and apply fix"
        echo "  --uninstall  Remove services and fix"
        echo "  --apply      Apply codec coefficients (run by systemd)"
        echo "  --status     Check if fix is installed"
        echo "  --help       Show this help"
        ;;
    *)
        if [ -t 0 ]; then
            show_tui
        else
            apply_fix
        fi
        ;;
esac
