local hashids = require('hashids')
local fixtures = require('fixtures')


unpack = unpack or table.unpack


describe('test hashids', function()

  it('can import clib.so', function()
    assert.has_no.errors(function() require('hashids.clib') end)
    assert.is.equal(type(require('hashids.clib')), 'table')
  end)

  describe('encode using default params', function()

    local hids = hashids.new()

    for hash, numbers in pairs(fixtures) do
      local numbers_repr
      if type(numbers) == 'table' then
        numbers_repr = '{' .. table.concat(numbers, ', ') .. '}'
      else
        numbers_repr = tostring(numbers)
        numbers = {numbers}
      end

      it(('should encode %s to %s'):format(numbers_repr, hash), function()
        assert.is.equal(hids:encode(unpack(numbers)), hash)
      end)

    end

  end)

end)
