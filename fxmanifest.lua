fx_version 'cerulean'
game 'gta5'
author 'FutureService'
client_scripts {
    'client/main.lua',
}
server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua',
}
shared_scripts {
    '@es_extended/imports.lua',
    "config.lua",
}