#!/usr/bin/env bash

#-------------------------------------------------------------------------------
# install-retropie.py
# KillSwitch
#
# Copyright © 2019 Dana Hynes <danahynes@gmail.com>
# This work is free. You can redistribute it and/or modify it under the terms
# of the Do What The Fuck You Want To Public License, Version 2, as published
# by Sam Hocevar. See the LICENSE file for more details.
#-------------------------------------------------------------------------------

# set strings for retropie's installer menu
rp_module_id="killswitch"
rp_module_desc="Turn your RetroPie on and off using an infrared remote"
rp_module_help="Use the main menu entry for KillSwitch to change the settings"
rp_module_section="exp"

# retropie will download killswitch's dependencies
#function depends_killswitch() {
#}

#    getDepends "libsdl2-dev"
#
# retropie will download killswitch's sources
function sources_killswitch() {
    gitPullOrClone "$md_build" "https://github.com/danahynes/KillSwitch.git"
}

# the fun part
function install_killswitch() {

    # get the menu xml and the entry to add
    local gamelistxml="$datadir/retropiemenu/gamelist.xml"
    local rpmenu_js_sh="$datadir/retropiemenu/killswitch-settings.sh"

    # link the installed file to the menu
    #ln -sfv "$md_inst/killswitch-settings.py" "$rpmenu_js_sh"
    ln -sfv "$md_inst/Software/Bash/killswitch-settings.sh" "$rpmenu_js_sh"

    # maybe the user is using a partition that doesn't support symbolic links...
    #[[ -L "$rpmenu_js_sh" ]] || cp -v "$md_inst/killswitch-settings.py" "$rpmenu_js_sh"

    # copy menu icon
    #cp -v "$md_build/icon.png" "$datadir/retropiemenu/icons/killswitch-settings.png"


    cp -nv "$configdir/all/emulationstation/gamelists/retropie/gamelist.xml" "$gamelistxml"
    if grep -vq "<path>./killswitch-settings.sh</path>" "$gamelistxml"; then
        xmlstarlet ed -L -P -s "/gameList" -t elem -n "gameTMP" \
            -s "//gameTMP" -t elem -n path -v "./killswitch-settings.sh" \
            -s "//gameTMP" -t elem -n name -v "KillSwitch Settings" \
            -s "//gameTMP" -t elem -n desc -v "Turn your RetroPie on and off using an infrared remote" \
            -r "//gameTMP" -v "game" \
            "$gamelistxml"

            #-s "//gameTMP" -t elem -n image -v "./icons/joystick_selection.png" \
        # XXX: I don't know why the -P (preserve original formatting) isn't working,
        #      The new xml element for joystick_selection tool are all in only one line.
        #      Then let's format gamelist.xml.
        local tmpxml=$(mktemp)
        xmlstarlet fo -t "$gamelistxml" > "$tmpxml"
        cat "$tmpxml" > "$gamelistxml"
        rm -f "$tmpxml"
    fi

    # needed for proper permissions for gamelist.xml and icons/joystick_selection.png
    chown -R $user:$user "$datadir/retropiemenu"

    #md_ret_files=(
    #    'jslist'
    #    'jsfuncs.sh'
    #    'joystick_selection.sh'
    #)
    md_ret_files=(
        'killswitch-settings.sh'
    )
}

# retropie will remove killswitch
#function remove_killswitch() {
    #
    # # run uninstaller
    # bash "$md_inst/Software/Bash/killswitch-uninstall.sh"
    #
    # #rm -rfv "$configdir"/*/joystick-selection.cfg "$datadir/retropiemenu/icons/joystick_selection.png" "$datadir/retropiemenu/joystick_selection.sh"
    #
    # # remove entry from main menu
    # xmlstarlet ed -P -L -d "/gameList/game[contains(path,'killswitch-settings.sh')]" "$datadir/retropiemenu/gamelist.xml"
#}

# no gui, same as running from cmd line
#function gui_killswitch() {
    # bash "$md_inst/killswitch-settings.sh"
#}
