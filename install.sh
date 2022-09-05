prepare() {
    if [[ "$EUID" -ne 0 ]]; then
        echo "[!] Error: you cannot run this script unless you are root"
        exit 1
    fi
    echo "[*] Installing dependencies..."
    pacman -Syu --needed --noconfirm bash sed coreutils diffutils grep
    HOOK_PATH="/etc/pacman.d/hooks"
    SCRIPT_PATH="/etc/pacman.d/scripts"
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

gen_backup_name() {
    local name="$1.install-comments-hook.bak"
    if [[ ! -e "$name" ]]; then
        printf "%s" "$name"
    else
        local -i num=1
        while [[ -e "$name$num" ]]; do
            num+=1
        done
        printf "%s%d" "$name" "$num"
    fi
}

install() {
    HOOK="99-install-comments.hook"
    echo "[*] Coping ${HOOK} to ${HOOK_PATH}..."
    cp ./99-install-comments.hook "$HOOK_PATH"
    chmod +x "$HOOK_PATH"
    SCRIPT="install-comments-hook"
    echo "[*] Coping ${SCRIPT} to ${SCRIPT_PATH}..."
    cp ./install-comments-hook "$SCRIPT_PATH"
    PACMAN_CONF="/etc/pacman.conf"
    PACMAN_CONF_BACKUP="$(gen_backup_name ${PACMAN_CONF})"
    PACMAN_CONF_OPTION="HookDir = ${HOOK_PATH}"
    if grep -Fxq "^${PACMAN_CONF_OPTION}\(\s\+\|$\)" "$PACMAN_CONF"
    then
        echo "[i] No need to backup pacman.conf"
    else
        echo "[*] Backup ${PACMAN_CONF} to ${PACMAN_CONF_BACKUP}..."
        cp "$PACMAN_CONF" "${PACMAN_CONF_BACKUP}"
        echo "[*] Modifying ${PACMAN_CONF}..."
        sed -i "/^\[options\]\(\s\+\|$\)/a ${PACMAN_CONF_OPTION}" "$PACMAN_CONF"
    fi
    echo "[+] Done!"
}

prepare
install
