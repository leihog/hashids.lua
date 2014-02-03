
![hashids](http://www.hashids.org.s3.amazonaws.com/public/img/hashids.png
"Hashids")

======

A Lua implementation of [http://www.hashids.org/](hashids).
This was ported from and should be compatible with v0.3.1 of [http://www.hashids.org/php/](hashids.php).

## What is it?

hashids (Hash ID's) creates short, unique, reversible hashes from unsigned integers.

_(NOTE: This is **NOT** a true cryptographic hash, since it is reversible)_

It was designed to use for URL shortening and id obfuscation.

This algorithm tries to satisfy the following requirements:

1. Hashes must be unique and decryptable.
2. They should be able to contain more than one integer (so you can use them in complex or clustered systems).
3. You should be able to specify minimum hash length.
4. Hashes should not contain basic English curse words (since they are meant to appear in public places - like the URL).

Instead of showing items as `1`, `2`, or `3`, you could show them as `jR`, `k5`, and `l5`.
You don't have to store these hashes in the database, but can encrypt + decrypt on the fly.

All integers need to be greater than or equal to zero.

## Basic usage

### Method signatures


	table new([salt], [min_hash_length], [alphabet]);
	string encrypt(int[, int, ...]);
	table decrypt(hash);
	

### Encrypting one number

You can pass a unique salt value so your hashes differ from everyone else's. 
I use **this is my salt** as an example.


	local hashids = require("hashids");
	local h = hashids.new("this is my salt")
	hash = h:encrypt(1337)


`hash` is now going to be `Wzo`


Encrypting multiple numbers with a minimum hash length set to 8.

	local hashids = require("hashids");
	local h = hashids.new("this is my salt", 8)
	hash = h:encrypt(1337, 10, 666)


`hash` is now going to be `xZRTxFPx`


### Decrypting

Decrypting a salted hash.

	local h = hashids.new("this is my salt")
	local numbers = h:decrypt("Wzo")

`numbers` is now going to be a table `{ 1 = 1337 }`

Decrypting a hash made from multiple numbers using a minimum hash length of 8.

	local h = hashids.new("this is my salt", 8);
	local numbers = h:decrypt("yamleqbk");
	
`numbers` now contains the table `{ 1 = 1337, 2 = 10, 3 = 666 }`

### Custom alphabet

It's also possible to set a custom alphabet for your hashes.
The default alphabet contains all lowercase and uppercase letters and numbers.

	local h = hashids.new("this is my salt", 8, "abcdefghijklmnopqrstuvwxyz");
	print(h:encrypt(1337));
	
will print `yamleqbk`


Curses! #$%@
-------

This code was written with the intent of placing created hashes in visible places - like the URL. Which makes it unfortunate if generated hashes accidentally formed a bad word.

Therefore, the algorithm tries to avoid generating most common English curse words. This is done by never placing the following letters next to each other:
	
	c, C, s, S, f, F, h, H, u, U, i, I, t, T

	
Install
-------

To install hashids.lua edit the include paths in `Makefile` to match your system and then type `make`. After compiling copy the `hashids/` folder to your lua lib path usually `/usr/local/lib/lua/5.1` or `/usr/lib/lua/5.1`.

	
### Using hashids without C library

Lua doesn't support string indexing `c = str[1];` and strings in Lua are immutable,
as a result certain string operations are quite costly. In an attempt to make these more efficient an optional but highly recommended C library is provided.

If speed isn't an issue for you (it likely wont be) you may choose to install **hashids.lua** without the C library. To do so just rename the file `hashids/init.lua` to `hashids.lua` and place it somewhere in your path.

	
Notes
-------

- The method names encrypt/decrypt are missleading and should be named encode/decode because that is really what is going on. The reason I stuck with encrypt/decrypt is that I wanted the API to be familiar for users of other hashids implementations.


