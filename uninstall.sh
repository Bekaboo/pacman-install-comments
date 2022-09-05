prepare() {
    if [[ "$EUID" -ne 0 ]]; then
        echo "[!] Error: you cannot run this script unless you are root"
        exit 1
    fi
    return 0
}

delete_hook_and_script() {
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
    return 0
}

restore_pacman_conf() {
    PACMAN_CONF="/etc/pacman.conf"
    PACMAN_CONF_BACKUP="$(get_backup_name ${PACMAN_CONF})"
    if [[ -z $PACMAN_CONF_BACKUP ]]; then
        echo "[i] No pacman.conf backup found"
    else
        if [[ -f $PACMAN_CONF_BACKUP ]]; then
            echo "[*] Restoring ${PACMAN_CONF} from ${PACMAN_CONF_BACKUP}..."
            mv "$PACMAN_CONF_BACKUP" "$PACMAN_CONF"
        else
            echo "[i] There's no backup file to restore from"
        fi
    fi
    return 0
}

get_backup_name() {
    local name="$1.install-comments-hook.bak"
    if [[ ! -e "$name" ]]; then
        printf ""
    else
        local -i num=1
        while [ -e "$name$num" ]; do
            num+=1
        done
        let "num-=1"
        printf "%s%d" "$name" "$num"
    fi
}

finish() {
    echo "[i] Uninstall bash, sed, coreutils, diffutils, or grep if you no longer need them"
    echo "[+] Done!"
}

prepare
delete_hook_and_script
restore_pacman_conf
finish
