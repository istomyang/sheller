#!/usr/bin/env bash

# shellcheck disable=SC1091
source lib1.sh
# shellcheck disable=SC1091
source lib2.sh
# shellcheck disable=SC1091
source lib/lib3.sh
# shellcheck disable=SC1091
source lib/lib4.sh

function f1_main() {
	echo "f1"
}
