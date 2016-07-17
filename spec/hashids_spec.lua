local hashids = require('hashids')
local fixtures = require('fixtures')


unpack = unpack or table.unpack


local function repr(value)
  if type(value) == 'table' then
    return '{' .. table.concat(value, ', ') .. '}'
  end
  return value
end


local function ensure_table(value)
  if type(value) ~= 'table' then return {value} end
  return value
end


-- test misc
describe("test misc", function()

  it("can import clib.so", function()
    assert.has_no.errors(function() require('hashids.clib') end)
    assert.is_table(require('hashids.clib'))
  end)

  it("omitting salt arg is equivalent to empty salt string", function()
    local hids_omit = hashids.new()
    local hids_empty = hashids.new('')
    assert.is.equal(hids_omit.salt, '')
    assert.is.equal(hids_omit:encode(100), hids_empty:encode(100))
  end)

end)


-- test encode/decode
for salt, fixture in pairs(fixtures.numbers) do

  describe(("encode using salt '%s'"):format(salt), function()
    local hids = hashids.new(salt)
    for hash, numbers in pairs(fixture) do
      numbers = ensure_table(numbers)
      it(("should encode %s to '%s'"):format(repr(numbers), hash), function()
        assert.is.equal(hids:encode(unpack(numbers)), hash)
      end)
    end
  end)

  describe(("decode using salt '%s'"):format(salt), function()
    local hids = hashids.new(salt)
    for hash, numbers in pairs(fixture) do
      numbers = ensure_table(numbers)
      it(("should decode '%s' to %s"):format(hash, repr(numbers)), function()
        assert.is.same(hids:decode(hash), numbers)
      end)
    end
  end)

end


-- test encode_hex/decode_hex
for salt, fixture in pairs(fixtures.hex) do

  describe(("encode_hex using salt '%s'"):format(salt), function()
    local hids = hashids.new(salt)
    for hash, hex in pairs(fixture) do
      it(("should encode_hex '%s' to '%s'"):format(hex, hash), function()
        assert.is.equal(hids:encode_hex(hex), hash)
      end)
    end
  end)

  describe(("decode_hex using salt '%s'"):format(salt), function()
    local hids = hashids.new(salt)
    for hash, hex in pairs(fixture) do
      hex = hex:upper()
      it(("should decode_hex '%s' to '%s'"):format(hash, hex), function()
        assert.is.equal(hids:decode_hex(hash), hex)
      end)
    end
  end)

end


-- test min_hash_length
describe("min hash length", function()
  local hids1, hids2
  for min = 1, 5 do
    hids1 = hashids.new(nil, min)
    hids2 = hashids.new('\\\\\\!SaLT!///', min)
    for _, value in ipairs(fixtures.min_length) do
      value = ensure_table(value)
      it(("of value '%s' should be greater or equal than %d"):format(
          repr(value), min), function()
        assert.truthy(#hids1:encode(unpack(value)) >= min)
        assert.truthy(#hids2:encode(unpack(value)) >= min)
      end)
    end
  end
end)


-- test custom alphabet
describe("constructor with custom alphabet", function()
  local hids, salt, min_length, result
  for _, alphabet in ipairs(fixtures.alphabet) do
    if alphabet.error then
      it("should raise error if there are < 16 unique chars", function()
        assert.has_error(
          function() hashids.new(nil, nil, alphabet.set) end,
          'alphabet must contain at least 16 unique characters'
        )
      end)
    else
      it("should create hashids object and pass all checks", function()
        if not alphabet.tests then
          hashids.new(nil, nil, alphabet.set)
        else
          for _, test in ipairs(alphabet.tests) do
            salt, min_length = unpack(test.constructor_args or {})
            hids = hashids.new(salt, min_length, alphabet.set)
            result = hids[test.method](hids, unpack(test.method_args))
            assert.is.same(result, test.result)
          end
        end
      end)
    end
  end
end)
