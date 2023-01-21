fx_version 'adamant'
game 'gta5'

lua54 'yes'

version '1.0.0'

files {"dist/**"}
ui_page 'dist/index.html'

client_scripts {"client/client.lua"}
server_scripts {"server/server.lua"}

shared_script {"config.lua"}

exports {"ReqGetZone", "ReqCreateZone", "ReqSyncZone", "ReqUpdateZone", "ReqRemoveZone"}
