apply_fix() {
    local dev=$(get_codec_dev)

    if [[ -z "$dev" || ! -e "$dev" ]]; then
        echo -e "${RED}Error: ALC245 device not found.${NC}"
        return 1
    fi

    echo -e "${CYAN}Applying ALC245 coefficients to $dev...${NC}"

    set_coef() {
        hda-verb "$dev" 0x20 SET_COEF_INDEX "$1" > /dev/null
        hda-verb "$dev" 0x20 SET_PROC_COEF  "$2" > /dev/null
    }

    set_coef 0x06 0xe115
    set_coef 0x08 0x6a08
    set_coef 0x0f 0x00c2
    set_coef 0x1a 0x8c03
    set_coef 0x1b 0x4a4b
    set_coef 0x45 0xd689
    set_coef 0x46 0x00f4
    set_coef 0x49 0x0249
    set_coef 0x4a 0x21f0
    set_coef 0x63 0x0000
    set_coef 0x67 0x3000

    hda-verb "$dev" 0x01 SET_GPIO_MASK      0x00 > /dev/null
    hda-verb "$dev" 0x01 SET_GPIO_DIRECTION 0x00 > /dev/null
    hda-verb "$dev" 0x01 SET_GPIO_DATA      0x00 > /dev/null

    echo -e "${GREEN}Success: Audio coefficients applied.${NC}"
}
