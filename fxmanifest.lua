fx_version 'adamant'
game 'gta5'

author 'GSKillerF | xc110 On Discord'
description 'Police and FBI Engine Block Script'
version '1.0.0'

client_scripts {
    '@es_extended/locale.lua',
    'client.lua'
}

server_scripts {
    '@es_extended/locale.lua',
    '@mysql-async/lib/MySQL.lua',
    'server.lua'
}
dependencies {
    'es_extended'
}
