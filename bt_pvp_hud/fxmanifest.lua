fx_version 'cerulean'
game 'gta5'

author 'Benten'
version '2.0.0'

shared_script '@ox_lib/init.lua'

client_scripts {
    'client.lua'
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/script.js',
    'html/assets/heart.png',
    'html/assets/shield.png'
}

dependencies {
    'ox_lib'
}