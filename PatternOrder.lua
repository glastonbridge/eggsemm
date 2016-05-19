--[[


Copyright (c) 2016 Alex Shaw aka aldroid of slipstream.

    Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

If you like this software, consider buying me a beer.  If you hate this software,
please fix it.

]]

class 'PatternOrder'
  function PatternOrder:__init(song)
    self.order = song.sequencer.pattern_sequence
  end
  function PatternOrder:write(f)
    for i = 1, 256 do
      if i <= table.getn(self.order) then
        --print(i..":"..self.order[i])
        f:write(string.char(self.order[i]-1)) -- table is zero offset in XM
      else
        f:write(string.char(0))
      end
    end
  end
