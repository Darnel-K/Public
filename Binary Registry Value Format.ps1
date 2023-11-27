<#
# ############################################################################ #
# Filename: \Binary Registry Value Format.ps1                                  #
# Repository: Public                                                           #
# Created Date: Monday, November 27th 2023, 5:23:24 PM                         #
# Last Modified: Monday, November 27th 2023, 5:23:48 PM                        #
# Original Author: Darnel Kumar                                                #
# Author Github: https://github.com/Darnel-K                                   #
#                                                                              #
# Copyright (c) 2023 Darnel Kumar                                              #
# ############################################################################ #
#>

[byte[]](("0C,00,02,00,0B,01,00,00,60,00,00,00").Split(',') | ForEach-Object { "0x$_" })
