package = 'hashids'
version = '1.0.1-1'
source = {
  url = 'git://github.com/leihog/hashids.lua.git',
  tag = 'v1.0.1',
}
description = {
  summary = 'A Lua implementation of hashids',
  homepage = 'https://github.com/leihog/hashids.lua',
  license = 'MIT',
  maintainer = 'un.def <un.def@ya.ru>',
}
dependencies = {
  'lua >= 5.1',
}
build = {
  type = 'builtin',
  modules = {
    ['hashids.init'] = 'hashids/init.lua',
    ['hashids.clib'] = {
        sources = 'hashids/clib.c'
    },
  },
}
