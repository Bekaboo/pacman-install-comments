prepare() {
    if [[ "$EUID" -ne 0 ]]; then
        echo "[!] Error: you cannot run this script unless you are root"
        exit 1
    fi
    return 0
}

uninstall() {
    HOOK_PATH="/etc/pacman.d/hooks/"
    HOOK_FILE="/etc/pacman.d/hooks/99-install-comments.hook"
    SCRIPT_PATH="/etc/pacman.d/scripts/"
    SCRIPT_FILE="/etc/pacman.d/scripts/install-comments-hook"
    if [[ -f "$HOOK_FILE" ]]; then
        echo "[*] Removing ${HOOK_FILE}"
        rm "$HOOK_FILE"
        if [[ -z "$(ls -A ${HOOK_PATH})" ]]; then
            echo "[*] Removing ${HOOK_PATH}"
            rm -r "$HOOK_PATH"
        fi
    fi
    if [[ -f "$SCRIPT_FILE" ]]; then
        echo "[*] Removing ${SCRIPT_FILE}"
        rm "$SCRIPT_FILE"
        if [[ -z "$(ls -A ${SCRIPT_PATH})" ]]; then
            echo "[*] Removing ${SCRIPT_PATH}"
            rm -r "$SCRIPT_PATH"
        fi
    fi
    echo "[i] Uninstall bash, sed, coreutils, diffutils, or grep if you no longer need them"
    echo "[+] Done!"
    return 0
}

prepare
uninstall
