--[[


Copyright (c) 2016 Alex Shaw aka aldroid of slipstream.

    Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

If you like this software, consider buying me a beer.  If you hate this software,
please fix it.

]]

require 'XMWriterUtils'
require 'PatternOrder'
require 'XMHeader'
require 'XMPattern'
require 'XMInstrument'  

-- Menu location
local MENU_NAME = "Main Window:File:Export XM..."

--- Top level class

class 'XMWriter'
  -- for reference ftp://ftp.modland.com/pub/documents/format_documentation/FastTracker%202%20v2.04%20%28.xm%29.html
  function XMWriter:__init(song)
    self.song = song
    self.patterns = {}
    self.instruments = {}
    self:calculateTrackMap(song)
    self.header = XMHeader(song, table.getn(self.trackMap))
    
    for i,p in ipairs(song.patterns) do
      table.insert(self.patterns,XMPattern(p, self.trackMap))
    end
    
    for i,p in ipairs(song.instruments) do
      table.insert(self.instruments,XMInstrument(p))
    end
  end
   
  function XMWriter:toFile(path)
    local f = assert(io.open(path,'w'))
    print(f)
    self:write(f)
    f:close()
  end
  
  function XMWriter:calculateTrackMap(song)
    self.trackMap = {}
    for i,track in ipairs(song.tracks) do
      if track.type == renoise.Track.TRACK_TYPE_SEQUENCER then
        for j = 1, track.visible_note_columns do
          table.insert(self.trackMap, {track = i, col = j})
        end
      end
    end
  end
 
  function XMWriter:write(f)
    print(self.header)
    self.header:write(f)
    for x,p in ipairs(self.patterns) do
      p:write(f)
    end
    for x,i in ipairs(self.instruments) do
      i:write(f)
    end
  end

