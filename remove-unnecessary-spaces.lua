--[[
# MIT License
Copyright (c) 2023 Takahiro Onoshima

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

]]
local function getindex_before_and_after_cite(inlines)
  local res = {}
  for i = #inlines, 1, -1 do
    if not(i == 1) then
      if not(i == #inlines) then -- 末尾だとi+1が参照できないのでそれを避けるため
        if inlines[i].t == "Cite" then
          res[#res + 1] = i - 1
        elseif inlines[i-1].t == "Cite" and not(inlines[i+1].t == "Cite") then
          res[#res + 1] = i
        end
      else
        if inlines[i].t == "Cite" then
          res[#res + 1] = i - 1
        elseif inlines[i-1].t == "Cite" then
          res[#res + 1] = i
        end
      end
    end
  end
  return res
end

local function remove_space_before_zenkakko(inlines)
  for i = #inlines, 1, -1 do
    if inlines[i].t == "Str" and not(i == 1) then
      if string.find(inlines[i].text, "（") and inlines[i-1].t == "Space" then
        table.remove(inlines, i-1)
      end
    end
  end
  return inlines
end

function Para(elem)
  local index_before_and_after_cite = getindex_before_and_after_cite(elem.c)
  for i = 1, #index_before_and_after_cite do
    if elem.c[index_before_and_after_cite[i]].t == "Space" then
      table.remove(elem.c, index_before_and_after_cite[i])
    end
  end

  for i = 1, #elem.c do
    if elem.c[i].t == "Cite" then
      elem.c[i].c = remove_space_before_zenkakko(elem.c[i].c)
    end
  end
  return elem
end
