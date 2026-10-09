show_tui() {
    clear
    echo -e "${BLUE}${BOLD}==========================================================${NC}"
    echo -e "${BLUE}${BOLD}      Minisforum AI X1 (HX370) Audio Manager v$VERSION${NC}"
    echo -e "${BLUE}${BOLD}==========================================================${NC}"
    echo ""

    if is_installed; then
        echo -e "${GREEN}${BOLD}Status:${NC} The fix is currently installed."
        echo ""
        echo -ne "${YELLOW}${BOLD}Do you want to revert/uninstall the fix? (y/N): ${NC}"
        read choice < /dev/tty
        if [[ "$choice" =~ ^[Yy]$ ]]; then
            uninstall_fix
        else
            echo -e "\nNo changes made."
        fi
    else
        echo -e "${YELLOW}${BOLD}Status:${NC} The fix is not installed.${NC}"
        echo ""
        echo -ne "${CYAN}${BOLD}Do you want to apply and install the fix now? (y/N): ${NC}"
        read choice < /dev/tty
        if [[ "$choice" =~ ^[Yy]$ ]]; then
            check_hardware
            install_fix
        else
            echo -e "\nNo changes made."
        fi
    fi

    echo ""
    echo -e "${BLUE}==========================================================${NC}"
}
