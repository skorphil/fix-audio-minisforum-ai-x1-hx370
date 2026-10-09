#!/bin/bash
# Bundler for hx370-audio-fix

DIST_FILE="hx370-audio-fix.sh"
echo "Building $DIST_FILE..."

{
    echo "#!/bin/bash"
    echo "# =============================================================================="
    echo "# Minisforum AI X1 (HX370) Audio Fix - Standalone Bundle"
    echo "# Generated on $(date)"
    echo "# =============================================================================="
    echo ""
    
    # Embed Templates
    echo "SERVICE_TEMPLATE='$(cat templates/fix-audio-alc245.service)'"
    echo "RESUME_SERVICE_TEMPLATE='$(cat templates/fix-audio-alc245-resume.service)'"
    echo ""

    # Add source files
    cat src/constants.sh
    echo ""
    cat src/hardware.sh
    echo ""
    cat src/codec.sh
    echo ""
    cat src/service.sh
    echo ""
    cat src/tui.sh
    echo ""
    cat src/main.sh
} > "$DIST_FILE"

chmod +x "$DIST_FILE"
echo "✓ Build complete: $DIST_FILE"
