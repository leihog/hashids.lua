return {

  numbers = {

    [''] = {
      jR = 1,
      vm = 10,
      g56 = 100,
      ZgwE = 33333,
      gE3Y95MDwl = 33333e10,
      lYfo = {1, 2},
      kQcn = {0, 2},
      kQc6cV = {0, 0, 2},
      oYxu6xh3ytXMO6 = {123, 456, 789, 1000000},
    },

    ['foo bar'] = {
      N4 = 0,
      gr = 1,
      bG = 25,
      NqQ7g7dn = 10e10,
      WZi3UB = {1, 2, 3},
      N4s7sQspsv = {0, 0, 0, 0, 0},
    },

  },

  hex = {

    [''] = {
      XW = 'f',
      Q67 = '0f',
      wRz = 'FF',
      VOAGMNKv = 'deadf00d',
      wpVL4j9g = 'DEADBEEF',
      RpZjRDJq5wFzLP9xOjoNs0JyPv = 'F0f0F0f0F0f0F0f0F0f0F0f0F0f0F0',
    },

    ['salt!@#$%^'] = {
      ym = '0',
      APPB = 'f0F',
      Vydgqnw = 'badbeef',
      ZBD8zBmg0dtgB = 'bada55900dface',
    },

  },

  min_length = {1, 10, 20, 50, 100, 500, 1000, 5000, 10000, 100000, 1000000,
                {1, 2, 3}, {100, 200, 300}, {111111, 222222, 333333}},

  alphabet = {

    {
      set = 'abcd',
      error = true,
    },

    {
      set = '0123456789abcde',
      error = true,
    },

    {
      set = '0123456789abcde0123',
      error = true,
    },

    {
      set = '0123456789abcdef',
      tests = {
        {
          method = 'encode',
          method_args = {100},
          result = '34b',
        },
        {
          constructor_args = {nil, 10},
          method = 'encode',
          method_args = {100},
          result = 'bde234b258',
        },
        {
          constructor_args = {'!salt!', nil},
          method = 'encode',
          method_args = {100},
          result = 'dab',
        },
        {
          constructor_args = {'!salt!', 10},
          method = 'encode',
          method_args = {100},
          result = 'ab49dab965',
        },
      },
    },

    {
      set = 'cCsSfFhHuUiItTol',
      tests = {
        {
          method = 'encode',
          method_args = {0},
          result = 'ol',
        },
        {
          method = 'decode',
          method_args = {'lo'},
          result = {1},
        },
        {
          method = 'encode_hex',
          method_args = {'deadbeef'},
          result = 'loooloooolololoolooloooooloooloooo',
        },
        {
          method = 'decode_hex',
          method_args = {'loooloooolololoolooooolllllllloolo'},
          result = 'DEADF00D'
        },
        {
          method = 'encode',
          method_args = {1, 2, 3},
          result = 'oohloioo',
        },
      },
    },

    {
      set = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890',
    },

  },

}
