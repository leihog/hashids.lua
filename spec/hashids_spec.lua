-- local hashids = require('hashids')

describe('Test hashids', function()

  it('can import clib.so', function()
    assert.has_no.errors(function() require('hashids.clib') end)
    assert.is.equal(type(require('hashids.clib')), 'table')
  end)

end)
