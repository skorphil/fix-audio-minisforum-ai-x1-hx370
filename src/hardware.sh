check_dependencies() {
    if ! command -v hda-verb >/dev/null; then
        echo -e "${YELLOW}Dependency 'hda-verb' (alsa-tools) is missing.${NC}"
        if command -v apt >/dev/null; then
            echo -ne "Would you like to install alsa-tools via apt? (Y/n): "
            read choice < /dev/tty
            [[ "$choice" =~ ^[Nn]$ ]] || apt update && apt install -y alsa-tools
        elif command -v dnf >/dev/null; then
            echo -ne "Would you like to install alsa-tools via dnf? (Y/n): "
            read choice < /dev/tty
            [[ "$choice" =~ ^[Nn]$ ]] || dnf install -y alsa-tools
        else
            echo -e "${RED}Please install alsa-tools manually using your package manager.${NC}"
            exit 1
        fi
    fi
}

check_hardware() {
    local product_name=$(cat /sys/class/dmi/id/product_name 2>/dev/null || echo "Unknown")
    local board_name=$(cat /sys/class/dmi/id/board_name 2>/dev/null || echo "Unknown")
    
    # AI Series / F8BSC are the identifiers for Minisforum AI X1
    if [[ "$product_name" != *"AI Series"* && "$board_name" != *"F8BSC"* ]]; then
        echo -e "${YELLOW}${BOLD}Warning:${NC} This hardware ($product_name / $board_name) is not verified for this fix."
        echo -ne "Do you want to continue anyway? (y/N): "
        read choice < /dev/tty
        if [[ ! "$choice" =~ ^[Yy]$ ]]; then
            exit 1
        fi
    fi
}

get_codec_dev() {
    local dev=$(grep -rl "ALC245" /proc/asound/card*/codec#0 2>/dev/null \
        | grep -o 'card[0-9]*' | head -1 \
        | sed 's/card/\/dev\/snd\/hwC/' | sed 's/$/D0/')
    echo "$dev"
}
