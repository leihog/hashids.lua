hashids.lua
===========

[![Build Status](https://travis-ci.org/un-def/hashids.lua.svg?branch=master)](https://travis-ci.org/un-def/hashids.lua)

A Lua implementation of [hashids][hashids].

**IMPORTANT:** This is a *fork* of [hashids.lua][leihog_hashids] by [leihog][leihog_twitter]. For original README see [README_leihog.md][original_readme].




### Motivation

This fork was initially started as a PR (Pull Request) to [leihog’s repository][leihog_hashids] that fixes C code compilation error with Lua > 5.1. But after writing some unit tests I found several bugs in Lua code, and due to the fact that leihog did not respond to my PR, I decided to continue to develop my fork as a separate project.



### Compatibility

Tested with:
* Lua 5.1, 5.2, and 5.3
* LuaJIT 2.0 and 2.1



### Installation

```
$ luarocks install hashids
```



### Testing

Test runner requires [busted][busted] and [LuaRocks][luarocks].

```
$ ./run_tests.sh [OPTIONS]
```

Options:

* `--verbose` run busted in verbose mode
* `--local` install package locally (into “user” rock tree)
* `--preserve` don’t remove installed package after tests

Although `--local` option allows to install packages under unprivileged user, it’s recommended to use environment manager (e.g., [luamb][luamb]) for isolation (don’t forget to install busted in new environment).



[hashids]: http://hashids.org/
[leihog_hashids]: https://github.com/leihog/hashids.lua
[leihog_twitter]: https://twitter.com/leihog
[original_readme]: https://github.com/un-def/hashids.lua/blob/master/README_leihog.md
[busted]: https://olivinelabs.com/busted/
[luarocks]: https://luarocks.org/
[luamb]: https://github.com/un-def/luamb
