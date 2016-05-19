--[[


Copyright (c) 2016 Alex Shaw aka aldroid of slipstream.

    Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

If you like this software, consider buying me a beer.  If you hate this software,
please fix it.

]]

 function write_dword(f,num)
  local byte1 = bit.band(0xFF,num)
  local byte2 = bit.band(bit.rshift(num, 8), 0xFF)
  local byte3 = bit.band(bit.rshift(num,16), 0xFF)
  local byte4 = bit.band(bit.rshift(num,24), 0xFF)
  --print(num.."="..byte1..":"..byte2..":"..byte3..":"..byte4)
  f:write(string.char(byte1))
  f:write(string.char(byte2))
  f:write(string.char(byte3))
  f:write(string.char(byte4))
end
 function write_word(f,num)
  local byte1 = bit.band(0xFF,num)
  local byte2 = bit.band(bit.rshift(num, 8), 0xFF)
  --print(num.."="..byte1..":"..byte2)
  f:write(string.char(byte1))
  f:write(string.char(byte2))
end

 function write_word_be(f,num)
  local byte1 = bit.band(0xFF,num)
  local byte2 = bit.band(bit.rshift(num, 8), 0xFF)
  --print(num.."="..byte1..":"..byte2)
  f:write(string.char(byte2))
  f:write(string.char(byte1))
 
end
 function write_byte_array(f, bytes)
  for i,b in ipairs(bytes) do
    f:write(string.char(b))
  end
end

function write_string_padded(f, topad, len)
    if topad:len() > len then
      topad = topad:sub(0,20)
    end
    f:write(topad)
    local pads = len - topad:len()
    for i = 1, pads do
      f:write(string.char(0))
    end
end

function print_r ( t )  
    local print_r_cache={}
    local function sub_print_r(t,indent)
        if (print_r_cache[tostring(t)]) then
            print(indent.."*"..tostring(t))
        else
            print_r_cache[tostring(t)]=true
            if (type(t)=="table") then
                for pos,val in pairs(t) do
                    if (type(val)=="table") then
                        print(indent.."["..pos.."] => "..tostring(t).." {")
                        sub_print_r(val,indent..string.rep(" ",string.len(pos)+8))
                        print(indent..string.rep(" ",string.len(pos)+6).."}")
                    elseif (type(val)=="string") then
                        print(indent.."["..pos..'] => "'..val..'"')
                    else
                        print(indent.."["..pos.."] => "..tostring(val))
                    end
                end
            else
                print(indent..tostring(t))
            end
        end
    end
    if (type(t)=="table") then
        print(tostring(t).." {")
        sub_print_r(t,"  ")
        print("}")
    else
        sub_print_r(t,"  ")
    end
    print()
end
