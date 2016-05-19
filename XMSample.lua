--[[


Copyright (c) 2016 Alex Shaw aka aldroid of slipstream.

    Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

If you like this software, consider buying me a beer.  If you hate this software,
please fix it.

]]

class 'XMSample'
  function XMSample:__init(renoiseSample)
    -- most objects extract the salient data in the constructor
    -- but samples are bigger
    self.renoiseSample = renoiseSample
    print(self.renoiseSample.name)
  end
  function XMSample:writeHeader(f)
    local renoiseSample = self.renoiseSample
    print(self.renoiseSample.name)
    write_dword(f,renoiseSample.sample_buffer.number_of_frames*2)
    print(renoiseSample.sample_buffer.number_of_frames*2)
    write_dword(f,renoiseSample.loop_start)
    write_dword(f,renoiseSample.loop_end- renoiseSample.loop_start)
    f:write(string.char(math.floor(renoiseSample.volume*32)))
    f:write(string.char(math.floor(renoiseSample.fine_tune/8)))
    if (renoiseSample.loop_mode == renoise.Sample.LOOP_MODE_OFF) then
      f:write(string.char(16))
    elseif (renoiseSample.loop_mode == renoise.Sample.LOOP_MODE_FORWARD) then
      f:write(string.char(17))
    else
      f:write(string.char(18))
    end
    f:write(string.char(math.floor(255*renoiseSample.panning)))
    f:write(string.char(0x1d))
    f:write(string.char(0))
    write_string_padded(f, renoiseSample.name, 22)
  end
  function XMSample:writeData(f)
    local renoiseSample = self.renoiseSample
    local mag = (2^15-1)
    local prev = 0
    local curr = 0
    print("Frames = "..renoiseSample.sample_buffer.number_of_frames)
    for si = 1,renoiseSample.sample_buffer.number_of_frames do
      prev = curr
      --print(si)
      curr = math.floor(renoiseSample.sample_buffer:sample_data(1,si)*mag)
      local d = bit.band(curr-prev, 0xffff)
      --write_word(f,math.floor(d))
      --print("p"..prev.."d"..d)
      write_word(f,d)
    end
    --
  end

