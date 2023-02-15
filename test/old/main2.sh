#!/usr/bin/env bash

# dirname "${BASH_SOURCE[0]}"
# for i in "${BASH_SOURCE[@]}"; do
# 	echo "123123"
# 	echo "$i"
# done

# pwd >&1

# echo '--------'

# # shellcheck disable=SC1091
# source "/Users/yangyang/Workspaces/Projects/sheller/common.sh"
# # shellcheck disable=SC1091
# source "/Users/yangyang/Workspaces/Projects/sheller/path.sh"

# p=$(sr_source_abs_path)

# echo "$p"

# function f() {
# 	a=${1:-100}
# 	b=${2:-200}
# 	echo $a
# 	echo $b
# }

# function dwd() {
# cd dirname "${BASH_SOURCE[0]}" || pwd -P
# dirname "${BASH_SOURCE[0]}"
#cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P && cd - && return

# 在脚本启动时候，BASH_SOURCE 已经确定值。
# dirname "${BASH_SOURCE[0]}"
# for i in "${BASH_SOURCE[@]}"; do
# 	echo "123123"
# 	echo "$i"
# done

# abs_path="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
# echo $abs_path
# }
