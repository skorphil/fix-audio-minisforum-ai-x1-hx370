install_fix() {
    echo -e "${CYAN}Installing fix...${NC}"
    
    # Check dependencies first
    check_dependencies
    
    # Copy this script to the install path
    cp "$0" "$INSTALL_PATH"
    chmod +x "$INSTALL_PATH"
    
    # Create service files from embedded templates
    echo "Creating systemd services..."
    echo "$SERVICE_TEMPLATE" > "/etc/systemd/system/$SERVICE_NAME"
    echo "$RESUME_SERVICE_TEMPLATE" > "/etc/systemd/system/$RESUME_SERVICE_NAME"
    
    systemctl daemon-reload
    systemctl enable "$SERVICE_NAME"
    systemctl start "$SERVICE_NAME"
    systemctl enable "$RESUME_SERVICE_NAME"
    
    echo -e "${GREEN}✓ Installation complete and services enabled.${NC}"
}

uninstall_fix() {
    echo -e "${YELLOW}Uninstalling fix...${NC}"
    
    systemctl stop "$SERVICE_NAME" 2>/dev/null || true
    systemctl disable "$SERVICE_NAME" 2>/dev/null || true
    systemctl disable "$RESUME_SERVICE_NAME" 2>/dev/null || true
    
    rm -f "/etc/systemd/system/$SERVICE_NAME"
    rm -f "/etc/systemd/system/$RESUME_SERVICE_NAME"
    rm -f "$INSTALL_PATH"
    
    systemctl daemon-reload
    
    echo -e "${GREEN}✓ Uninstallation complete.${NC}"
}

is_installed() {
    if [[ -f "/etc/systemd/system/$SERVICE_NAME" ]]; then
        return 0
    else
        return 1
    fi
}
