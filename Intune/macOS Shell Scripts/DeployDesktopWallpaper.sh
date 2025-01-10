#!/bin/bash
# #################################################################################################################### #
# Filename: \Intune\macOS Shell Scripts\DeployDesktopWallpaper.sh                                                      #
# Repository: Public                                                                                                   #
# Created Date: Saturday, January 4th 2025, 9:40:30 PM                                                                 #
# Last Modified: Friday, January 10th 2025, 10:26:56 PM                                                                #
# Original Author: Darnel Kumar                                                                                        #
# Author Github: https://github.com/Darnel-K                                                                           #
# Github Org: https://github.com/ABYSS-ORG-UK/                                                                         #
#                                                                                                                      #
# This code complies with: https://gist.github.com/Darnel-K/8badda0cabdabb15359350f7af911c90                           #
#                                                                                                                      #
# License: GNU General Public License v3.0 only - https://www.gnu.org/licenses/gpl-3.0-standalone.html                 #
# Copyright (c) 2024 Darnel Kumar                                                                                      #
#                                                                                                                      #
# This program is free software: you can redistribute it and/or modify                                                 #
# it under the terms of the GNU General Public License as published by                                                 #
# the Free Software Foundation, either version 3 of the License, or                                                    #
# (at your option) any later version.                                                                                  #
#                                                                                                                      #
# This program is distributed in the hope that it will be useful,                                                      #
# but WITHOUT ANY WARRANTY; without even the implied warranty of                                                       #
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the                                                        #
# GNU General Public License for more details.                                                                         #
# #################################################################################################################### #

exec 3>&1 1>"/tmp/IntuneDeployedScripts.log" 2>&1
set -x

echo "Deploying Base64 encoded wallpaper" >&3
echo "Script Started: $(date -Is)"

B64="" # Base64 encoded image string. Use a site like Base64 Guru (https://base64.guru/converter/encode/image) to endode your image to a Base64 string.
WALLPAPER_PATH="" # Full path to where the image will be stored without a trailing slash (/). File path will be created if it doesn't exist. If left blank the root directory will be used.
WALLPAPER_FILENAME="" # The file name you'd like to save the decoded image to including the file extension.

mkdir -pv "${WALLPAPER_PATH}"

base64 -d <<< "$B64" > "${WALLPAPER_PATH}/${WALLPAPER_FILENAME}"
chmod -Rvv 644 "${WALLPAPER_PATH}/${WALLPAPER_FILENAME}"
chown -Rvv root:wheel "${WALLPAPER_PATH}/${WALLPAPER_FILENAME}"
