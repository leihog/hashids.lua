local hashids = require('hashids')
local fixtures = require('fixtures')
local fixtures_hex = require('fixtures_hex')


unpack = unpack or table.unpack


local function table_repr(tbl)
  return '{' .. table.concat(tbl, ', ') .. '}'
end


-- test misc
describe("test misc", function()

  it("can import clib.so", function()
    assert.has_no.errors(function() require('hashids.clib') end)
    assert.is.equal(type(require('hashids.clib')), 'table')
  end)

  it("omitting salt arg is equivalent to empty salt string", function()
    local hids_omit = hashids.new()
    local hids_empty = hashids.new('')
    assert.is.equal(hids_omit.salt, '')
    assert.is.equal(hids_omit:encode(100), hids_empty:encode(100))
  end)

end)


-- test encode/decode
for salt, fixture in pairs(fixtures) do

  describe(("encode using salt '%s'"):format(salt), function()
    local hids = hashids.new(salt)
    for hash, numbers in pairs(fixture) do
      local numbers_repr
      if type(numbers) == 'table' then
        numbers_repr = table_repr(numbers)
      else
        numbers_repr = tostring(numbers)
        numbers = {numbers}
      end
      it(("should encode %s to '%s'"):format(numbers_repr, hash), function()
        assert.is.equal(hids:encode(unpack(numbers)), hash)
      end)
    end
  end)

  describe(("decode using salt '%s'"):format(salt), function()
    local hids = hashids.new(salt)
    for hash, numbers in pairs(fixture) do
      if type(numbers) == 'number' then
        numbers = {numbers}
      end
      local numbers_repr = table_repr(numbers)
      it(("should decode '%s' to %s"):format(hash, numbers_repr), function()
        assert.is.same(hids:decode(hash), numbers)
      end)
    end
  end)

end


-- test encode_hex/decode_hex
for salt, fixture in pairs(fixtures_hex) do

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
