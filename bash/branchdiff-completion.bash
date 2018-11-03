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


function _local_branches(){
    ##
    ##  returns an array of git branches listed by the
    ##  local git repository
    ##
    declare -a local_branches

    local_branches=(  $(git branch 2>/dev/null |  grep -v remotes | cut -c 3-50)  )
    echo "${local_branches[@]}"
    #
    # <--- end function _clean_subcommands --->
}


function _remote_branchnames(){
    ##
    ##  returns an array of git branches listed by the
    ##  remote repository
    ##
    declare -a remotes

    remotes=(  $(git branch -a 2>/dev/null |  grep remotes | tail -n +2 | awk -F '/' '{print $NF}')  )
    echo "${remotes[@]}"
    #
    # <--- end function _clean_subcommands --->
}


function _complete_alternatebranch_commands(){
    ##
    ##
    ##
    local cmds="$1"
    local split='4'       # times to split screen width
    local ct="0"
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


function _complete_branchdiff_commands(){
    local cmds="$1"
    local split='4'       # times to split screen width
    local ct="0"
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
    initcmd="${COMP_WORDS[COMP_CWORD-2]}"
    #echxo "cur: $cur, prev: $prev"

    # initialize vars
    COMPREPLY=()
    numargs=0
    numoptions=0

    # option strings
    commands='--branch --code --help --version'

    # subcommand sets
    remote_branches=$(_remote_branchnames)

    case "${initcmd}" in

        '--branch')
            return 0
            ;;

    esac

    case "${cur}" in

        '--version')
            return 0
            ;;

    esac

    case "${prev}" in

        '--branch')
            #_complete_alternatebranch_commands "${local_branchnames}"
            COMPREPLY=( $(compgen -W "${remote_branches}" -- ${cur}) )
            return 0
            ;;

        '--version' | '--help')
            return 0
            ;;

        "branchdiff")
            if [ "$cur" = "" ] || [ "$cur" = "-" ] || [ "$cur" = "--" ]; then

                _complete_branchdiff_commands "${commands}"
                return 0

            fi
            ;;
    esac

    COMPREPLY=( $(compgen -W "${commands}" -- ${cur}) )

} && complete -F _branchdiff_completions branchdiff
