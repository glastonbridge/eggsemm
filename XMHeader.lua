--[[


Copyright (c) 2016 Alex Shaw aka aldroid of slipstream.

    Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

If you like this software, consider buying me a beer.  If you hate this software,
please fix it.

]]

require 'XMWriterUtils'
-- consts
local EXPORTER_NAME = "RenoiseXMX          "
class 'XMHeader'
  function XMHeader:__init(song, numberOfChannels)
    self.name="Module name"
    self.songlength = table.getn(song.sequencer.pattern_sequence)
    self.headersize = 276 -- this seems to be fixed?  confused...
    self.restartposition = 0
    self.numberofchannels = numberOfChannels 
    self.numberofpatterns = table.getn(song.patterns)
    self.numberofinstruments = table.getn(song.instruments)
    self.defaulttempo = 6
    self.defaultbpm = song.transport.bpm
    self.patternorder = PatternOrder(song)
  end
  function XMHeader:write(f)
    print(f)
    f:write("Extended Module: ")
    write_string_padded(f, self.name, 20)
    f:write(string.char(0x1a))
    write_string_padded(f, EXPORTER_NAME, 20)
    -- version
    f:write(string.char(0x04))
    f:write(string.char(0x01))
    -- header size (why?)
    write_dword(f, self.headersize)
    write_word(f, self.songlength)
    write_word(f, self.restartposition)
    write_word(f, self.numberofchannels)
    print("channels "..self.numberofchannels)
    write_word(f, self.numberofpatterns)
    write_word(f, self.numberofinstruments)
    print("instruments "..self.numberofinstruments)
    -- flags ???
    f:write(string.char(0x01))
    f:write(string.char(0x00))
    write_word(f, self.defaulttempo)
    write_word(f, self.defaultbpm)
    self.patternorder:write(f)
  end
  
