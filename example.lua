package.path = package.path .. ";./?/init.lua";

local alphabet = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890";
local hashids = require("hashids");
local h = hashids.new(nil, 8, alphabet);

local ts = os.time();
print(h:encrypt(34, 2525));

local hash;
for i = 1, 10000 do
	h:decrypt(h:encrypt(i, 2525));
end

print(h:encrypt(1337, 10, 666));
print("elapsed time (in seconds):", os.time() - ts);
