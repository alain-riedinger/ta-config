--[[--------------------------------------------------
Put a color hint under a color code, among possible formats:
- 0xBBGGRR
- #RRGGBB

[SciTE Pane API](https://www.scintilla.org/PaneAPI.html)
[Scintilla Documentation](https://www.scintilla.org/ScintillaDoc.html)
=> to convert from SciTE API
--]]----------------------------------------------------

require('util')

local mark_color = 6   -- identifier of mark to use to set a color hint

--[[
Toggle the activation of the color hint
]]
function color_hint_switch()
	local prop_name = 'highlighting.color.hint'
	buffer.property[prop_name] = 1 - tonumber(buffer.property[prop_name])
	Util.editor_clear_marks(mark_color)
end

--[[
Set a color hint under the current color code
]]
local function color_hint_setter()
	local cur_text = buffer.get_sel_text(buffer)
	if cur_text:find('^%s+$') then return end
	if cur_text == '' then
		cur_text = Util.get_current_word()
	end

	Util.editor_clear_marks(mark_color)
	
  if Util.is_color(cur_text) then
    local current_pos = buffer.current_pos
    local color_start, color_end
    color_start = buffer.word_start_position(buffer, current_pos, true)
    color_end = buffer.word_end_position(buffer, current_pos, true)
    local color = cur_text
    
    ui.statusbar_text = color
    
    Util.editor_mark_text_colour(mark_color, color_start, color_end-color_start, color)
  end
end

events.connect(events.UPDATE_UI, function(updated)
  if tonumber(buffer.property['highlighting.color.hint']) == 1 then
    if updated ~= nil then
      if Util.land(updated, buffer.UPDATE_CONTENT) == buffer.UPDATE_CONTENT or
         Util.land(updated, buffer.UPDATE_SELECTION) == buffer.UPDATE_SELECTION then 
         color_hint_setter()
      end
    end
  end
end)
