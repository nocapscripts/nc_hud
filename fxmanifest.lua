

fx_version "cerulean"
game "gta5"
lua54 "yes"
author 'RedEyeScripts'
description "RedEyeScript status HUD"
version '2.0.5'


shared_scripts {
    "shared/**/*",
    '@rs_base/import.lua',
}

client_scripts {
    "client/utils.lua",
    "client/variables.lua",
    "client/functions.lua",
    "client/events.lua",
    "client/nui.lua",
    "client/threads.lua"
}

server_scripts {
    "server/variables.lua",
    "server/functions.lua",
    "server/commands.lua",
    "server/events.lua",
    "server/threads.lua"
}

ui_page "html/index.html"

files {
    "locales/**/*",
    "html/index.html",
    "html/**/*"
}


