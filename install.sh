prepare() {
    if [[ "$EUID" -ne 0 ]]; then
        echo "[!] Error: you cannot run this script unless you are root"
        exit 1
    fi
    echo "[*] Installing dependencies..."
    pacman -Syu --needed --noconfirm bash sed coreutils diffutils grep
    HOOK_PATH="/etc/pacman.d/hooks/"
    SCRIPT_PATH="/etc/pacman.d/scripts/"
    if [[ ! -d "$HOOK_PATH" ]]; then
        echo "[*] Hook path ${HOOK_PATH} does not exit, creating..."
        mkdir -p "$HOOK_PATH"
    fi
    if [[ ! -d "$SCRIPT_PATH" ]]; then
        echo "[*] Script path ${SCRIPT_PATH} does not exit, creating..."
        mkdir -p "$SCRIPT_PATH"
    fi
    return 0
}

install() {
    HOOK="99-install-comments.hook"
    echo "[*] Coping ${HOOK} to ${HOOK_PATH}..."
    cp ./99-install-comments.hook "$HOOK_PATH"
    chmod +x "$HOOK_PATH"
    SCRIPT="install-comments-hook"
    echo "[*] Coping ${SCRIPT} to ${SCRIPT_PATH}..."
    cp ./install-comments-hook "$SCRIPT_PATH"
    echo "[+] Done!"
}

prepare
install
