hashids.lua
===========

[![Build Status](https://travis-ci.org/un-def/hashids.lua.svg?branch=master)](https://travis-ci.org/un-def/hashids.lua)

**IMPORTANT:** This is a *fork* of [original hashids.lua][leihog/hashids] by leihog.



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



[leihog/hashids]: https://github.com/leihog/hashids.lua
[busted]: https://olivinelabs.com/busted/
[luarocks]: https://luarocks.org/
[luamb]: https://github.com/un-def/luamb
