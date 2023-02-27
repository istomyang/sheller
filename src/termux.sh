#!/usr/bin/env bash

#################################################################
#######                                                 #########
#######                     自定义                       #########
#######                                                 #########
#################################################################

function sr_termux_deploy() {

	echo "Change repo source."
	termux-change-repo

	echo "Allow storage access."
	termux-setup-storage

	echo "Link phone's folder to home"
	mkdir -p "$HOME/storage/shared/Documents/termux"
	ln -s "$HOME/termux" "$HOME/storage/shared/Documents/termux"
	ln -s "$HOME/documents" "$HOME/storage/shared/Documents"
	ln -s "$HOME/download" "$HOME/storage/shared/Download"
	cd "$HOME" && ls

	echo "Update local repo."
	pkg update && pkg upgrade

	echo "Install OpenSSH"
	# If you meet with some lib not found, please pkg update && pkg upgrade.
	# If you meet with hotkeys not found, please ssh-keygen -A.
	# After install openssh, use port 8022 is default, see `man sshd_config` search Port.
	pkg install openssh
	ssh-keygen -A

	local readShortcut
	read -rp "Can install touch keyboard shortcut? [NO|yes] > " readShortcut
	if [[ "${readShortcut:-yes}" == "yes" ]]; then
		echo "Install touch keybord shortcut."
		cat <<'_EOF_' >>"$HOME/.termux/termux.properties"
extra-keys = [ \
['ESC',    '|',   '/',   'BACKSLASH' ,   'UP',    'END',    '-',      'QUOTE'],  \
['TAB',   'CTRL', 'ALT',   'LEFT',      'DOWN',   'RIGHT',  '+' , 'APOSTROPHE'],  \
['[]', '<>', '{}', '_', '&', '*',';',':','KEYBOARD'] \
]
_EOF_
	fi
}
