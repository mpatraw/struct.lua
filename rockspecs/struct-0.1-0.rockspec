package = 'struct'
version = '0.1-0'
source = {
    url = 'git://github.com/mpatraw/struct.lua',
    tag = 'v0.1'
}
description = {
    summary = 'type-checked table definitions',
    detailed = [[
    ]],
    homepage = 'http://mpatraw.github.io/struct.lua',
    license = 'ICS'
}
dependencies = {
    'lua => 5.1, <= 5.3'
}
build = {
    type = 'builtin',
    modules = {
        ['struct'] = 'struct.lua'
    },
}
