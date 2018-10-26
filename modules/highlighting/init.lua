--[[--------------------------------------------------
Highlighting identical text, among either:
- the selected text, if any
- the word in which the cursor is

[SciTE Pane API](https://www.scintilla.org/PaneAPI.html)
[Scintilla Documentation](https://www.scintilla.org/ScintillaDoc.html)
=> to convert from SciTE API
--]]----------------------------------------------------

require('util')

local count_max = 50   -- maximum number of items to highlight
local store_pos        -- stored previous position of cursor
local store_text       -- stored previous text highlighted
local mark_ident = 4   -- identifier of mark to use to highlight each occurence
local mark_max = 5     -- identifier of mark to signal that number of occurences is above max
local chars_count      -- count of characters in editor
local word_pattern     -- pattern defining a word, if no selection

local alpha = 15			    -- alpha for the inside of the marker
local outlinealpha = 150	-- alpha for the border of the marker

local max = buffer.property['highlighting.identical.text.max']
if max ~= '' then count_max = tonumber(max) end

-- Colors for highlighting
color_ident = 0x00FF00
color_error = 0x0000FF

--[[
Toggle the activation of the highlighting
]]
function highlighting_identical_text_switch()
	local prop_name = 'highlighting.identical.text'
	buffer.property[prop_name] = 1 - tonumber(buffer.property[prop_name])
	Util.editor_clear_marks(mark_ident)
	store_pos, store_text = 0, ''
end

--[[
Find the items that shall be highlighted
]]
local function identical_text_finder()
	local current_pos = buffer.current_pos
	if current_pos == store_pos then return end
	store_pos = current_pos

	local cur_text = buffer.get_sel_text(buffer)
	if cur_text:find('^%s+$') then return end
	local find_flags = buffer.FIND_MATCHCASE
	if cur_text == '' then
		cur_text = Util.get_current_word()
		find_flags = find_flags + buffer.FIND_WHOLEWORD
	end
	if cur_text == store_text then return end
	store_text = cur_text

	Util.editor_clear_marks(mark_ident)
	Util.editor_clear_marks(mark_max)
	
  local match_table = {}
  -- Search in the complete buffer, with the previously defined search flags
  buffer.search_flags = find_flags
  buffer.target_start = 0
  buffer.target_end = buffer.length
  repeat
    buffer.target_end = buffer.length
    local ident_text_start = buffer.search_in_target(buffer, cur_text)
    if ident_text_start < 0 then break end
    ident_text_end = ident_text_start + string.len(cur_text)
    match_table[#match_table+1] = {ident_text_start, ident_text_end}
    if count_max ~= 0 then
      if #match_table > count_max then
        -- Too many occurences: mark the initial one with error style
        local err_start, err_end
        if find_flags == buffer.FIND_MATCHCASE then
          err_start = buffer.selection_start
          err_end = buffer.selection_end
          Util.editor_mark_text_alpha(mark_max, err_start, err_end-err_start, color_error, alpha, outlinealpha)
          return
        else
          err_start = buffer.word_start_position(buffer, current_pos, true)
          err_end = buffer.word_end_position(buffer, current_pos, true)
          Util.editor_mark_text_alpha(mark_max, err_start, err_end-err_start, color_error, alpha, outlinealpha)
          return
        end
      end
    end
    buffer.target_start = ident_text_end + 1
  until false
  if #match_table > 1 then
    -- Mark the found occurences with marking style
    for i = 1, #match_table do
      Util.editor_mark_text_alpha(mark_ident, match_table[i][1], match_table[i][2]-match_table[i][1], color_ident, alpha, outlinealpha)
    end
  end
end

events.connect(events.UPDATE_UI, function(updated)
  if tonumber(buffer.property['highlighting.identical.text']) == 1 then
    if updated ~= nil then
      if Util.land(updated, buffer.UPDATE_CONTENT) == buffer.UPDATE_CONTENT then 
        if buffer.length ~= chars_count then
          chars_count = buffer.length
        end
      end
      if Util.land(updated, buffer.UPDATE_SELECTION) == buffer.UPDATE_SELECTION then 
      end
      identical_text_finder()
    end
  end
end)

--[[
  [[code] [textadept] The UPDATE_UI event from Hugh Low on 2016-03-22 (code)](https://foicica.com/lists/code/201603/3111.html)
local counter, tbl = 0, {}
events.connect(events.UPDATE_UI, function(mask)
  counter, tbl[15] = (counter + 1), nil
  table.insert(tbl, 1, string.format('[%d] = %d', counter, mask or 0))
  ui.statusbar_text = table.concat(tbl, ', ')
end)
]]

--[[
  events.connect(events.UPDATE_UI, function(mask)
    local ref = string.format('%x %x %x %x', buffer.UPDATE_CONTENT, buffer.UPDATE_SELECTION, buffer.UPDATE_V_SCROLL, buffer.UPDATE_H_SCROLL)
    local status = ''
    if mask == nil then 
      status = status..' nil'
    else
      if Util.land(mask, buffer.UPDATE_CONTENT) == buffer.UPDATE_CONTENT then status = status..' UPDATE_CONTENT' end
      if Util.land(mask, buffer.UPDATE_SELECTION) == buffer.UPDATE_SELECTION then status = status..' UPDATE_SELECTION' end
      if Util.land(mask, buffer.UPDATE_V_SCROLL) == buffer.UPDATE_V_SCROLL then status = status..' UPDATE_V_SCROLL' end
      if Util.land(mask, buffer.UPDATE_H_SCROLL) == buffer.UPDATE_H_SCROLL then status = status..' UPDATE_H_SCROLL' end
    end
    ui.statusbar_text = ref..' - '..(tostring(mask) or 'nil')..' - '..status
  end)
]]
