--[[--------------------------------------------------
A better approach for search:
- Ctrl+F proposes the search UI with either selected text if any, or current word
- Ctrl+F3 searches for the current word
--]]----------------------------------------------------

require('util')

Search = {}

--[[
Preloads the search UI with selection or current word
]]
function Search.preload_search_ui()
  -- Retrieve selected text, if any
	local cur_text = buffer.get_sel_text(buffer)
	if cur_text:find('^%s+$') then return end
	if cur_text == '' then
    -- Else retrieve current word
		cur_text = Util.get_current_word()
	end
  -- Display the search UI, preloaded, if any text
  ui.find.find_entry_text = cur_text
  ui.find.focus()
end

--[[
Search for current word
]]
function Search.search_current_word()
  -- Retrieve the current word, if any
  cur_text = Util.get_current_word()
  if cur_text == '' then return end
  -- Search for the next occurence of the current word, if any
  ui.find.find_entry_text = cur_text
  ui.find.find_next()
end
