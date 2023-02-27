--[[
# MIT License
Copyright (c) 2023 Takahiro Onoshima

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

]]

local str_from = {"　", "–", "’"} 
local str_to = {"\\hspace{1\\zw}", "--", "\'"}

local function contains_any(inline, table_str_to_find)
    if inline.t == "Str" then
        local res = false
        for i = 1, #table_str_to_find do
            res = res or string.find(inline.text, table_str_to_find[i])
        end
        return res
    else
        return false
    end
end

local function str_replace(strings, old_str, new_str)
    local res = ""
    indexstart = 1
    indexend = 0
    while indexstart do
        remaining_str = string.sub(strings, indexend + 1, #strings)
        slicestart = indexend + 1
        indexstart, indexend = string.find(strings, old_str, indexend+1)
        if indexend then
            res = res .. string.sub(strings, slicestart, indexstart-1) .. new_str
        else
            res = res .. remaining_str
        end
    end
    return res
end

function Span(elem)
    for i = 1, #elem.content do
        if contains_any(elem.content[i], str_from) then
            local temp_str = elem.content[i].text
            for j = 1, #str_from do
                temp_str = str_replace(temp_str, str_from[j], str_to[j])
            end
            if FORMAT:match 'latex' then
                elem.content[i] = pandoc.RawInline('latex', temp_str)
            end
        end
    end
    return elem
end
