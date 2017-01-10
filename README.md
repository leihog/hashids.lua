
Hashids.lua
=======

A Lua implementation of [hashids](http://www.hashids.org/).

## What is it?

hashids (Hash ID's) creates short, unique, reversible hashes from unsigned integers.
Checkout [hashids.org](http://hashids.org/) for more information about the
algorithm.


_(NOTE: This is **NOT** a true cryptographic hash, since it is reversible)_

It was designed to use for URL shortening and id obfuscation.

This algorithm tries to satisfy the following requirements:

1. Hashes must be unique and reversible.
2. They should be able to contain more than one integer (so you can use them in complex or clustered systems).
3. You should be able to specify minimum hash length.
4. Hashes should not contain basic English curse words (since they are meant to appear in public places - like the URL).

Instead of showing items as `1`, `2`, or `3`, you could show them as `jR`, `k5`, and `l5`.
You don't have to store these hashes in the database, but can encode/decode on the fly.

All integers need to be greater than or equal to zero.

## Install

To install hashids.lua edit the paths in `Makefile` to match your system and then type `make && make install`. 


### Using hashids without C library

Lua doesn't support string indexing `c = str[1];` and strings in Lua are immutable,
as a result certain string operations are quite costly. In an attempt to make these more efficient an optional but highly recommended C library is provided.

If speed isn't an issue for you (it likely wont be) you may choose to install **hashids.lua** without the C library. To do so just rename the file `hashids/init.lua` to `hashids.lua` and place it somewhere in your path.


## Usage


### Encoding

You can pass a unique salt value so your hashes differ from everyone else's. 
I use **this is my salt** as an example.


    local hashids = require("hashids");
    local h = hashids.new("this is my salt")
    hash = h:encode(1337)


`hash` is now going to be `Wzo`


You can also encode multiple numbers in to one hash.
In this example we set the minimum hash length to 8.

    local hashids = require("hashids");
    local h = hashids.new("this is my salt", 8)
    hash = h:encode(1337, 10, 666)


`hash` is now going to be `xZRTxFPx`


### Decoding

In order to decode a hash we need to setup hashids with the same parameters used
for encoding. In our above example we specified the salt **this is my salt** so
we use that here as well.

    local h = hashids.new("this is my salt")
    local numbers = h:decode("Wzo")

`numbers` is now going to be a table `{ 1 = 1337 }`

Decoding a hash made from multiple numbers using a minimum hash length of 8.

    local h = hashids.new("this is my salt", 8);
    local numbers = h:decode("yamleqbk");

`numbers` now contains the table `{ 1 = 1337, 2 = 10, 3 = 666 }`


### Working with Hexadecimals

The convenience methods encode_hex/decode_hex allow us to work with
hexadecimals without first converting them.

    local h = hashids.new("this is my salt")
    local hash = h:encode_hex("0FF")


`hash` now contains the string `"7WPd"`

    local h = hashids.new("this is my salt")
    local hex = h:decode_hex("7WPd")

`hex` contains the string `"0FF"`


The caveat is that all hexadecimals are assumed to be strings.
The following will not work

    local h = hashids.new("this is my salt")
    local hash = h:encode_hex(0x0FF)

Since a hexadecimal is a number you can pass it to encode, but encode and
encode_hex will not generate the same result.

    local h = hashids.new("this is my salt")
    hash = h:encode(0x0FF) -- hash = "K6y"
    hash = h:encode_hex("0FF") -- hash = "7WPd"


### Custom alphabet

It's also possible to set a custom alphabet for your hashes.
The default alphabet contains all lowercase and uppercase letters and numbers.

    local h = hashids.new("this is my salt", 8, "abcdefghijklmnopqrstuvwxyz")
    print(h:encode(1337))
    
will print `yamleqbk`


## Curses! #$%@

This code was written with the intent of placing created hashes in visible places - like the URL. Which makes it unfortunate if generated hashes accidentally formed a bad word.

Therefore, the algorithm tries to avoid generating most common English curse words. This is done by never placing the following letters next to each other:
    
    c, C, s, S, f, F, h, H, u, U, i, I, t, T


## Changelog

**1.0.5**

 - Fixes issue with min_hash_length in 5.3 (submitted by un.def)
 - Use table.unpack if unpack is not available. Affects 5.3 and 5.2 without LUA_COMPAT_UNPACK. (submitted by un.def)
 - Fixed bug in clib that would hinder functions from registering. Affected Lua > 5.1 (submitted by un.def)

**1.0.0**

 - Public functions renamed to be more appropriate (encode/decode)
 - Added convenience functions for working with hexadecimals (encode_hex/decode_hex)

**0.3.0**

 - First version of hashids.lua compatible with Hashids 0.3 except it lacked the hex functions

