package = 'hashids'
version = '1.0.6-1'
source = {
  url = 'git://github.com/leihog/hashids.lua.git',
  tag = 'v1.0.6',
}
description = {
  summary = 'A Lua implementation of hashids',
  homepage = 'https://github.com/leihog/hashids.lua',
  license = 'MIT',
  maintainer = 'Leif Högberg <leihog@gmail.com>',
}
dependencies = {
  'lua >= 5.1',
}
build = {
  type = 'builtin',
  modules = {
    ['hashids.init'] = 'src/init.lua',
    ['hashids.clib'] = {
        sources = 'src/clib.c'
    },
  },
}
