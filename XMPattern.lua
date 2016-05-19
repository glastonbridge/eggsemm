--[[


Copyright (c) 2016 Alex Shaw aka aldroid of slipstream.

    Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

If you like this software, consider buying me a beer.  If you hate this software,
please fix it.

]]

require 'XMWriterUtils'

class 'XMPattern'
  function XMPattern:__init(renoisePattern, trackMap)
    self.headerlength = 9 -- ?
    self.packingtype = 0
    self.numrows = renoisePattern.number_of_lines
    self:readPatternData(renoisePattern, trackMap)
  end
  -- The biggie!
  function XMPattern:readPatternData(renoisePattern, trackMap)
    self.data = ""
    for line = 1, self.numrows do
      for i, track in ipairs(trackMap) do
        local thisline = renoisePattern:track(track.track):line(line)
        local note = 0
        local inst = 0
        local volu = 0
        local effn = 0
        local effv = 0
        if table.getn(thisline.note_columns)>0 then
          note = thisline:note_column(track.col).note_value + 1
          inst = thisline:note_column(track.col).instrument_value + 1 
          volu = thisline:note_column(track.col).volume_value
          if volu == 255 then
          volu = 0
          else
            if volu > 127 then volu = 127 end
            volu = volu / 2
          end
          if inst== 256 then inst = 255 end -- todo wtf?
          if note == 122 then -- NO NOTE
            note = 0
            inst = 0
            volu = 0
          elseif note == 121 then -- NOTE OFF
            note = 97
            inst = 0
            volu = 0
          --effn = thisline:effect_column(1).number_value
          --effv = thisline:effect_column(1).amount_value -- todo: map these
          end
        end
        
        self.data = self.data..string.char(note)..string.char(inst)..string.char(volu)..string.char(0)..string.char(0)
      end
    end
  end
  function XMPattern:write(f)
    
    --f:write("PHD");
    write_dword(f,self.headerlength)
    f:write(string.char(self.packingtype))
    write_word(f,self.numrows)
    write_word(f,self.data:len())
    
    --f:write("PDA");
    f:write(self.data)
  end
