--[[


Copyright (c) 2016 Alex Shaw aka aldroid of slipstream.

    Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

If you like this software, consider buying me a beer.  If you hate this software,
please fix it.

]]

require 'XMSample'
  
class 'XMInstrument'
  function XMInstrument:__init(renoiseInstrument)
    self.headersize = 29 -- ??
    self.name = renoiseInstrument.name
    self.type = 0
    self.numsamples =  table.getn(renoiseInstrument.samples)
    if self.numsamples > 0 then
      self.headersize = 243
    end
    self.samples = {}
    for i,s in ipairs(renoiseInstrument.samples) do
      table.insert(self.samples, XMSample(s))
    end
    self.sampleheadersize = 30
    self.samplenumbers = {}
    for i = 1,96 do
      table.insert(self.samplenumbers,0)
    end
    self.volumeenvelope = {}
    for i = 1,48 do
      table.insert(self.volumeenvelope,255)
    end
    self.panningenvelope = {}
    for i = 1,48 do
      table.insert(self.panningenvelope,127)
    end
    self.numberofpanningpoints = 0
    self.numberofvolumepoints = 0
    self.volumesustainpoint = 0
    self.volumeloopstart = 0
    self.volumeloopend = 0
    self.panningsustainpoint = 0
    self.panningloopstartpoint = 0
    self.panningloopendpoint = 0
    self.volumetype = 0
    self.panningtype = 0
    self.vibratotype = 0
    self.vibratosweep = 0
    self.vibratodepth = 0
    self.vibratorate = 0
    self.volumefadeout = 0
  end
  
  function XMInstrument:write(f)
  
    --f:write("PHI");
    write_dword(f, self.headersize)
    write_string_padded(f, self.name, 22)
    f:write(string.char(self.type))
    write_word(f,self.numsamples)
    if self.numsamples > 0 then
      write_dword(f, self.sampleheadersize)
      write_byte_array(f,self.samplenumbers)
      write_byte_array(f,self.volumeenvelope)
      write_byte_array(f,self.panningenvelope)
      f:write(string.char(self.numberofvolumepoints))
      f:write(string.char(self.numberofpanningpoints))
      f:write(string.char(self.volumesustainpoint))
      f:write(string.char(self.volumeloopstart))
      f:write(string.char(self.volumeloopend))
      f:write(string.char(self.panningsustainpoint))
      f:write(string.char(self.panningloopstartpoint))
      f:write(string.char(self.panningloopendpoint))
      f:write(string.char(self.volumetype))
      f:write(string.char(self.panningtype))
      f:write(string.char(self.vibratotype))
      f:write(string.char(self.vibratosweep))
      f:write(string.char(self.vibratodepth))
      f:write(string.char(self.vibratorate))
      write_word(f,self.volumefadeout)
      write_word(f,0) -- reserved
      for i,sx in ipairs(self.samples) do
        print(sx.renoiseSample.name)
        sx:writeHeader(f)
      end
      for i,sx in ipairs(self.samples) do
        sx:writeData(f)
      end
      print("written "..self.name)
    end
  end
