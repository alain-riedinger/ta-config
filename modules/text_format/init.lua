--[[--------------------------------------------------
Text formatting tools and helpers
--]]----------------------------------------------------

require('util')

TextFormat = {}

--[[
Splits a string (one liner) using a given separator
Returns a table of strings (without separator)
]]
function split (str, sep)
   if sep == nil then
      sep = "%s"
   end
   local t={}
   for substr in string.gmatch(str, "([^"..sep.."]+)") do
      table.insert(t, substr)
   end
   return t
end

--[[
Splits a text into lines
Returns a table of lines
]]
function split_lines(str)
  local t = {}
  local i, lstr = 1, #str
  while i <= lstr do
    local x, y = string.find(str, "\r?\n", i)
    if x then
      t[#t + 1] = string.sub(str, i, x - 1)
    else
      break
    end
    i = y + 1
  end
  if i <= lstr then 
    t[#t + 1] = string.sub(str, i)
  end
  return t
end

--[[
Formats a markdown table that has been selected in the editor
]]
function TextFormat.tablify()
  -- Retrieve selected text
  local sel_text = buffer.get_sel_text(buffer)
  if #sel_text == 0 then return end

  -- Split the test into lines
  local lines = split_lines(sel_text)
  
  local sep = '|'     -- Separator for the table items
  local lens = {}     -- Contains maximum length of text per column
  local parts = {}    -- Contains all the parts of the splitted text, line per line
  
  -- Parse all the lines of the text
  -- - extract the column items and store them (don't do this twice)
  -- - find greatest column width for each column
  for i,v in ipairs(lines) do
    -- Split the line into items, on given separator (not included)
	  local subs = split(v, '|')
	  parts[i] = subs
    -- Parse each part to get broadest column width
	  for j,w in ipairs(subs) do
  	  -- Check if length of split sub is greater: if yes store it
	    if lens[j] == nil then
	      lens[j] = 0
	    end
	    if #w > lens[j] then
	      lens[j] = #w
	    end
    end
	end

  local tablified_text = ''
  -- Compose the tablified text, with formatted columns
  for i,p in ipairs(parts) do
    local line = sep
    for j,s in ipairs(p) do
  		line = line .. s .. string.rep(' ', lens[j]-#s) .. sep
	  end
    if tablified_text ~= '' then
      tablified_text = tablified_text.."\n"
    end
    tablified_text = tablified_text..line
  end
  
  -- Replace the selected text with the tablified one
  buffer.replace_sel(buffer, tablified_text)
end
