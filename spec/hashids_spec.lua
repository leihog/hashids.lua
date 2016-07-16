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
describe("min_", function()
  local hids1, hids2
  for min = 1, 5 do
    hids1 = hashids.new(nil, min)
    hids2 = hashids.new('\\\\\\!SaLT!///', min)
    for _, value in ipairs(fixtures.min_length) do
      assert.truthy(#hids1:encode(value) >= min)
      assert.truthy(#hids2:encode(value) >= min)
    end
  end
end)
