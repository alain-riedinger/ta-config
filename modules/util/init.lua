--[[
[ta-tweaks/init.lua at master · gabdub/ta-tweaks](https://github.com/gabdub/ta-tweaks/blob/master/modules/util/init.lua)
]]

-- Table bearing the different methods
Util = {}

--[[---------------------------------------------------------------------------------------
For debugging and tracing
]]
-- In a new buffer called 'Debug'
function Util.debug(msg)
  ui._print('Debug', msg)
end
-- In the Status Bar: single line only
function Util.status(msg)
  ui.statusbar_text = msg
end

--[[---------------------------------------------------------------------------------------
Helpers for views and buffers
]]
-- Switches to an already opened view
function Util.goto_view(numview)
  if _VIEWS[view] ~= numview then
    ui.goto_view(_VIEWS[numview])
  end
end

-- Switches to an open buffer
function Util.goto_buffer(buf)
  view:goto_buffer(buf)
end

-- Resets the given marker
function Util.editor_clear_marks(style_number, start, length)
  local _first_style, _end_style, style
  local current_mark_number = buffer.indicator_current
  if style_number == nil then
    _first_style, _end_style = 0, 31
  else
    _first_style, _end_style = style_number, style_number
  end
  if start == nil then
    start, length = 0, buffer.length
  end
  for style = _first_style, _end_style do
    buffer.indicator_current = style
    buffer.indicator_clear_range(buffer, start, length)
  end
  buffer.indicator_current = current_mark_number
end

-- Set a given marker on a text portion
function Util.editor_mark_text_alpha(style_number, start, length, fore, alpha, outlinealpha)
  local current_mark_number = buffer.indicator_current
  buffer.indicator_current = style_number
  buffer.indic_style[style_number] = buffer.INDIC_STRAIGHTBOX
  buffer.indic_fore[style_number] = fore
  buffer.indic_alpha[style_number] = alpha
  buffer.indic_outline_alpha[style_number] = outlinealpha
  buffer.indicator_fill_range(buffer, start, length)
  buffer.indicator_current = current_mark_number
end

-- Set a given colour marker on a text portion 
function Util.editor_mark_text_colour(style_number, start, length, color)
  local current_mark_number = buffer.indicator_current
  buffer.indicator_current = style_number
  buffer.indic_style[style_number] = buffer.INDIC_COMPOSITIONTHICK 
  buffer.indic_fore[style_number] = color
  buffer.indicator_fill_range(buffer, start, length)
  buffer.indicator_current = current_mark_number
end

-- Returns the current word, ir where the cursor is located
function Util.get_current_word()
  local current_pos = buffer.current_pos
  local word_start = buffer.word_start_position(buffer, current_pos, true)
  local word_end   = buffer.word_end_position(buffer, current_pos, true)
  return buffer.text_range(buffer, word_start, word_end)
end

--[[
Check whether text is a colour code
There are 2 possible formats:
- 0xBBGGRR
- #RRGGBB
]]
function Util.is_color(text)
  -- In this first version: only 0x... format is coded
  if string.len(text) ~= 8 then return false end
  if not string.match(text, '^0x%x+$') then return false end
  return true
end

--[[---------------------------------------------------------------------------------------
Binary functions
]]
-- Return single bit (for OR)
function Util.bit(x,b)
  return (x % 2^b - x % 2^(b-1) > 0)
end

-- Logic NOT for number values
-- Returns the "opposite" of the number x
function Util.lnot(x)
  result = 0
  for p=1,16 do result = result + ((Util.bit(x,p) == true) and 0 or 2^(p-1)) end
  return result
end

-- Logic OR for number values
-- Returns the OR of the 2 numbers
function Util.lor(x,y)
  result = 0
  for p=1,16 do result = result + (((Util.bit(x,p) or Util.bit(y,p)) == true) and 2^(p-1) or 0) end
  return result
end

-- Logic AND for number values
-- Returns the AND of the 2 numbers
function Util.land(x,y)
  result = 0
  for p=1,16 do result = result + (((Util.bit(x,p) and Util.bit(y,p)) == true) and 2^(p-1) or 0) end
  return result
end

