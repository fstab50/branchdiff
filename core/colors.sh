#!/usr/bin/env bash

#------------------------------------------------------------------------------
#
#   colors.sh module | std colors for bash
#
#------------------------------------------------------------------------------
#   Bright ansi color codes:
#       Bright Black: \u001b[30;1m
#       Bright Red: \u001b[31;1m
#       Bright Green: \u001b[32;1m
#       Bright Yellow: \u001b[33;1m
#       Bright Blue: \u001b[34;1m
#       Bright Magenta: \u001b[35;1m
#       Bright Cyan: \u001b[36;1m
#       Bright White: \u001b[37;1m
#
#------------------------------------------------------------------------------


VERSION="2.0.1"


# --- standard bash color codes  ------------------------------------------------------------------


    # std color codes
    red=$(tput setaf 1)
    green=$(tput setaf 2)
    yellow=$(tput setaf 3)
    blue=$(tput setaf 4)
    purple=$(tput setaf 5)
    cyan=$(tput setaf 6)
    white=$(tput setaf 7)
    gray=$(tput setaf 008)

    # Formatting
    BOLD=`tput bold`
    UNBOLD=`tput sgr0`

    # std reset
    reset=$(tput sgr0)


# --- ansi color escape codes  --------------------------------------------------------------------


    # ansi color codes
    a_orange='\033[38;5;95;38;5;214m'
    a_wgray='\033[38;5;95;38;5;250m'                  # white-gray
    a_lgray='\033[38;5;95;38;5;245m'                  # light gray
    a_dgray='\033[38;5;95;38;5;8m'                    # dark gray

    # ansi bright colors
    a_brightblue='\033[38;5;51m'
    a_brightcyan='\033[38;5;36m'
    a_brightgreen='\033[38;5;95;38;5;46m'
    a_bluepurple='\033[38;5;68m'
    a_brightred='\u001b[31;1m'
    a_brightyellow='\033[38;5;11m'
    a_brightyellow2='\033[38;5;95;38;5;226m'
    a_brightyellowgreen='\033[38;5;95;38;5;155m'
    a_brightwhite='\033[38;5;15m'

    # ansi font formatting
    bold='\u001b[1m'                                # ansi format
    underline='\u001b[4m'                           # ansi format

    # ansi escape code reset
    resetansi='\u001b[0m'


# --- color print variables  ----------------------------------------------------------------------


    # Initialize ansi colors
    title=$(echo -e ${bold}${white})
    url=$(echo -e ${underline}${a_brightblue})
    options=$(echo -e ${white})
    commands=$(echo -e ${a_brightcyan})               # use for ansi escape color codes

    # frame codes (use for tables)                  SYNTAX:  color:format (bold, etc)
    pv_blue=$(echo -e ${a_brightblue})
    pv_bluebold=$(echo -e ${bold}${a_brightblue})
    pv_green=$(echo -e ${a_brightgreen})            # use for tables; green border faming
    pv_greenbold=$(echo -e ${bold}${a_brightgreen}) # use for tables; green bold border faming
    pv_orange=$(echo -e ${a_orange})                # use for tables; orange border faming
    pv_orangebold=$(echo -e ${bold}${a_orange})     # use for tables; orange bold border faming
    pv_white=$(echo -e ${a_brightwhite})            # use for tables; white border faming
    pv_whitebold=$(echo -e ${bold}${a_brightwhite}) # use for tables; white bold border faming

    pv_bodytext=$(echo -e ${reset}${a_wgray})             # main body text; set to reset for native xterm
    pv_bg=$(echo -e ${a_brightgreen})                     # brightgreen foreground cmd
    pv_bgb=$(echo -e ${bold}${a_brightgreen})             # bold brightgreen foreground cmd
    pv_wgray=$(echo -e ${a_wgray})
    pv_orange=$(echo -e ${a_orange})
    pv_wgray=$(echo -e ${a_wgray})
    pv_lgray=$(echo -e ${a_lgray})
    pv_dgray=$(echo -e ${a_dgray})

    # initialize default color scheme
    accent=$(tput setaf 008)                         # ansi format
    ansi_orange=$(echo -e ${a_orange})                 # use for ansi escape color codes

    # reset print variable
    RESET=$(echo -e ${resetansi})


# --- declarations  -------------------------------------------------------------------------------


    # indent, x spaces
    function indent02() { sed 's/^/  /'; }
    function indent04() { sed 's/^/    /'; }
    function indent10() { sed 's/^/          /'; }
    function indent15() { sed 's/^/               /'; }
    function indent18() { sed 's/^/                  /'; }
    function indent20() { sed 's/^/                    /'; }
    function indent25() { sed 's/^/                         /'; }


# --- aliases  ------------------------------------------------------------------------------------

    # alias for legacy backard compatibility
    alias orange=$a_orange
    alias wgray=$a_wgray
    alias lgray=$a_lgray
    alias dgray=$a_dgray
    alias bodytext=$pv_bodytext
    alias blue_frame=$pv_blue
    alias bluebold_frame=$pv_bluebold
    alias green_frame=$pv_green
    alias greenbold_frame=$pv_greenbold
    alias orange_frame=$pv_orange
    alias orangebold_frame=$pv_orangebold
    alias white_frame=$pv_white
    alias whitebold_frame=$pv_whitebold
    alias brightblue=$a_brightblue
    alias brightcyan=$a_brightcyan
    alias brightgreen=$a_brightgreen
    alias bluepurple=$a_bluepurple
    alias brightred=$a_brightred
    alias brightyellow=$a_brightyellow
    alias brightyellow2=$a_brightyellow2
    alias brightyellowgreen=$a_brightyellowgreen
    alias brightwhite=$a_brightwhite
