#!/usr/bin/env bash

# GPL v3 License
#
# Copyright (c) 2018 Blake Huber
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the 'Software'), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.


function _current_downloads(){
    ##
    ##  Examines local fs for downloaded artifacts
    ##
    ##      - returns entry for each python binary set downloaded to /tmp
    ##
    local index="0"
    declare -a arr_targets xz tgz

    xz=( $(find /tmp -name \*.tar.xz 2>/dev/null) )
    tgz=( $(find /tmp -name \*.tgz 2>/dev/null) )

    for i in "${xz[@]}"; do
        temp="$(echo $i | awk -F '.tar' '{print $1}' | awk -F '.' '{print $1"."$2}')"
        xz[$index]=$(echo $temp | awk -F '/' '{print $NF}')
        (( index++ ))
    done

    index="0"

    for i in "${tgz[@]}"; do
        temp="$(echo $i | awk -F '.tgz' '{print $1}' | awk -F '.' '{print $1"."$2}')"
        tgz[$index]=$(echo $temp | awk -F '/' '{print $NF}')
        (( index++ ))
    done

    arr_targets=( $(echo "${xz[@]}") $(echo "${tgz[@]}") )
    echo "${arr_targets[@]}"
    #
    # <--- end function _clean_subcommands --->
}


function _complete_branchdiff_commands()
{
  local cmds="$1"
  local split='4'       # times to split screen width
  local IFS=$' \t\n'
  local formatted_cmds=( $(compgen -W "${cmds}" -- "${COMP_WORDS[1]}") )

  for i in "${!formatted_cmds[@]}"; do
      formatted_cmds[$i]="$(printf '%*s' "-$(($COLUMNS/$split))"  "${formatted_cmds[$i]}")"
  done

  COMPREPLY=( "${formatted_cmds[@]}")
  return 0
  #
  # <-- end function _complete_branchdiff_commands -->
}


function _branchdiff_completions(){
    ##
    ##  Completion structures for branchdiff exectuable
    ##
    local numargs numoptions cur prev prevcmd

    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    prevcmd="${COMP_WORDS[COMP_CWORD-2]}"
    #echo "cur: $cur, prev: $prev"

    # initialize vars
    COMPREPLY=()
    numargs=0
    numoptions=0

    # option strings
    commands='-b --branch -c --code -h --help -V --version'

    # subcommand sets
    branch_subcommands="$(_branch_subcommands) ALL"

    #echo -e "CUR: $cur, PREV: $prev"       # debug

    case "${cur}" in
        '--info' | '--version' | '--backup-pip')
            return 0
            ;;

        'Python-'[0-9].[0-9])
            case "${prev}" in
                '--install')
                    COMPREPLY=( $(compgen -W "${install_options}" -- ${cur}) )
                    return 0
                    ;;
                *)
                    return 0
                    ;;
            esac
            ;;
    esac

    case "${prev}" in

        '--branch')
            COMPREPLY=( $(compgen -W "${clean_subcommands}" -- ${cur}) )
            return 0
            ;;

        '--code' | '--version' | '--help')
            return 0
            ;;

        "branchdiff")
            if [ "$cur" = "" ] || [ "$cur" = "--" ]; then

                _complete_branchdiff_commands "${commands}"
                return 0

            fi
            ;;
    esac

    COMPREPLY=( $(compgen -W "${commands}" -- ${cur}) )

} && complete -F _branchdiff_completions branchdiff
