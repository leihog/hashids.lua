local ceil   = math.ceil
local floor  = math.floor
local pow    = math.pow
local substr = string.sub
local upcase = string.upper
local format = string.format
local strcat = table.concat
local push   = table.insert
local unpack = table.unpack or unpack
local str_switch_pos

local ok, lib = pcall(require, "hashids.clib");
if ok then
    str_switch_pos = lib.str_switch_pos;
else
    str_switch_pos = function(str, pos1, pos2)
        pos1 = pos1 + 1; pos2 = pos2 + 1;
        local a,b = str:sub(pos1,pos1), str:sub(pos2, pos2);
        if pos1 > pos2 then return str:gsub(a, b, 1):gsub(b, a, 1); end
        return str:gsub(b, a, 1):gsub(a, b, 1);
    end
end


hash_mt = {};
hash_mt.__index = hash_mt;

local function gcap(str, pos)
    pos = pos + 1;
    return str:sub(pos, pos);
end

-- TODO using string concatenation with .. might not be the fastest in a loop
local function hash(number, alphabet)
    local hash, alen = "", alphabet:len();
    repeat
        hash = gcap(alphabet, (number % alen)) .. hash;
        number = floor(number / alen);
    until number == 0

    return hash;
end

local function unhash(input, alphabet)
    local number, ilen, alen = 0, input:len(), alphabet:len();

    for i=0, ilen do
        local cpos = (alphabet:find(gcap(input, i), 1, true) - 1);
        number = number + cpos * pow(alen, (ilen - i - 1))
    end

    return number;
end

local function consistent_shuffle(alphabet, salt)
    local slen = salt:len();
    if slen == 0 then return alphabet end

    local v, p = 0, 0;
    for i = (alphabet:len() - 1), 1, -1 do
        v = (v % slen);
        local ord = gcap(salt, v):byte();
        p = p + ord;
        local j = (ord + v + p) % i;

        alphabet = str_switch_pos(alphabet, j, i);
        v = v + 1;
    end

    return alphabet;
end

function hash_mt:encode(...)
    local numbers = {select(1,...)};
    if #numbers == 0 then return "" end
    local numbers_size, hash_int = #numbers, 0;

    for i, number in ipairs(numbers) do
        assert(type(number) == 'number', "all paramters must be numbers");
        hash_int = hash_int + (number % ((i - 1) + 100));
    end

    local alpha = self.alphabet;
    local alpha_len = alpha:len();

    local lottery = gcap(alpha, hash_int % alpha_len);
    local ret = lottery;
    local last = nil;

    for i, number in ipairs(numbers) do
    -- for i=1, #numbers do
    -- local number = numbers[i];
        alpha = consistent_shuffle(alpha, substr(strcat({lottery, self.salt, alpha}), 1, alpha_len));
        last = hash(number, alpha);
        ret = ret .. last;

        if i < numbers_size then
            number = number % (last:byte() + (i - 1));
            ret = ret .. gcap(self.seps, (number % self.seps:len()));
        end
    end

    local guards_len = self.guards:len();
    if ret:len() < self.min_hash_length then
        local guard_index = (hash_int + gcap(ret, 0):byte()) % guards_len;
        ret = gcap(self.guards, guard_index) .. ret;

        if ret:len() < self.min_hash_length then
            guard_index = (hash_int + gcap(ret, 2):byte()) % guards_len;
            ret = ret .. gcap(self.guards, guard_index);
        end
    end

    local half_len, excess = floor(alpha_len * 0.5), 0; -- alpha_len / 2
    while ret:len() < self.min_hash_length do
        alpha = consistent_shuffle(alpha, alpha);
        ret = alpha:sub(half_len + 1) .. ret .. alpha:sub(1, half_len);

        excess = (ret:len() - self.min_hash_length);
        if excess > 0 then
            excess = (excess * 0.5);
            ret = ret:sub(floor(excess + 1), floor(excess + self.min_hash_length));
        end
    end

    return ret;
end

function hash_mt:encode_hex(str)
    if str:match("%X") then return "" end
    local pos, max, numbers = 0, #str, {}
    while true do
        local part = substr(str, pos + 1, pos + 12)
        if part == "" then break end
        pos = pos + #part
        push(numbers, tonumber("1" .. part, 16))
    end

    return self:encode(unpack(numbers))
end

function hash_mt:decode(hash)
    -- TODO validate input

    local parts, index = {}, 1;
    for part in hash:gmatch("[^".. self.guards .."]+") do
        parts[index] = part;
        index = index + 1;
    end

    local num_parts, t, lottery = #parts;
    if num_parts == 3 or num_parts == 2 then
        t = parts[2];
    else
        t = parts[1];
    end

    lottery = gcap(t, 0); -- put the first char in lottery
    t = t:sub(2); -- then put the rest in t

    parts, index = {}, 1;
    for part in t:gmatch("[^".. self.seps .."]+") do
        parts[index] = part;
        index = index + 1;
    end

    local ret, alpha = {}, self.alphabet;
    for i=1, #parts do
        alpha = consistent_shuffle(alpha, substr(strcat({lottery, self.salt, alpha}), 1, self.alphabet_length));
        ret[i] = unhash(parts[i], alpha);
    end

    return ret;
end

function hash_mt:decode_hex(hash)
    local result, numbers = {}, self:decode(hash)
    for _, number in ipairs(numbers) do
        push(result, substr(format("%x", number), 2))
    end

    return upcase(strcat(result))
end

return {
    VERSION = "1.0.6",
    new = function(salt, min_hash_length, alphabet)
        salt = salt or "";
        min_hash_length = min_hash_length or 0;
        alphabet = alphabet or "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890";
        -- TODO make sure alphabet doesn't contain duplicates.

        local tmp_seps, tmp_alpha, c = "", "";
        local seps = "cfhistuCFHISTU";

        for i = 1, alphabet:len() do
            c = alphabet:sub(i,i);

            if seps:find(c, 1, true) then
                tmp_seps = tmp_seps .. c;
            else
                tmp_alpha = tmp_alpha .. c;
            end
        end

        seps = consistent_shuffle(tmp_seps, salt);
        alphabet = tmp_alpha;

        -- constants
        local SEPS_DIV = 3.5;
        local GUARD_DIV = 12;

        if seps:len() == 0 or (alphabet:len() / seps:len()) > SEPS_DIV then
            local seps_len = floor(ceil(alphabet:len() / SEPS_DIV));
            if seps_len == 1 then seps_len = 2 end

            if seps_len > seps:len() then
                local diff = seps_len - seps:len();
                seps = seps .. alphabet:sub(1, diff);
                alphabet = alphabet:sub(diff + 1);
            else
                seps = seps:sub(1, seps_len);
            end
        end

        alphabet = consistent_shuffle(alphabet, salt);
        local guards = "";
        local guard_count = ceil(alphabet:len() / GUARD_DIV);
        if alphabet:len() < 3 then
            guards = seps:sub(1, guard_count);
            seps = seps:sub(guard_count + 1);
        else
            guards = alphabet:sub(1, guard_count);
            alphabet = alphabet:sub(guard_count + 1);
        end

        local obj = { salt = salt, alphabet = alphabet, seps = seps, guards = guards, min_hash_length = min_hash_length };
        return setmetatable(obj, hash_mt);
    end
}
