--[[--------------------------------------------------
Several helpers that enhance the day to day usage of TextAdept editor
Some sources of inspiration:
[reback00/ta-config: Config to customize Textadept to act more like Atom/$ublime text - NotABug.org: Free code hosting](https://notabug.org/reback00/ta-config/src/master/init.lua)
[Lua 5.3 Reference Manual - Basic UTF-8 Support](https://q-syshelp.qsc.com/Content/Control_Scripting/Lua_5.3_Reference_Manual/Standard_Libraries/4_-_Basic_UTF-8_Support.htm)

--]]----------------------------------------------------

require('util')

Enhanced = {}

--[[ 
Shows total number of selected characters in the statusbar
]]
events.connect(events.UPDATE_UI, function()
  if buffer.UPDATE_SELECTION ~= 0 then
    local text = buffer.get_sel_text(buffer)
		local selcount = utf8.len(text)
		if selcount > 0 then
			ui.statusbar_text = 'Chars: '..selcount
		else
			ui.statusbar_text = ''
		end
  end
end)

--[[ 
Computes statistics on the selected text
]]
function Enhanced.text_stats()
  -- Retrieve the selected text, if any, or the whole text else
  local text = buffer.get_sel_text(buffer)
  local infotext = 'selected text'
  if text == '' then
    text = buffer.get_text(buffer)
    infotext = 'whole text'
  end

  -- length of an UTF-8 string
  local nbc = utf8.len(text)

  -- Count by character types of the UTF-8 string
  local nb_chars = 0
  local nb_digits = 0
  local nb_spaces = 0
  local nb_signs = 0
  local nb_others = 0
  for p, c in utf8.codes(text) do
    local u = utf8.char(c)
    if string.find("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZàâéèêëïîöôù", u, 1, true) ~= nil then
      nb_chars = nb_chars + 1
    elseif string.find("0123456789", u, 1, true) ~= nil then
      nb_digits = nb_digits + 1
    elseif string.find(" \t\n\r", u, 1, true) ~= nil then
      nb_spaces = nb_spaces + 1
    elseif string.find(".,;:!?/-+&'\"%", u, 1, true) ~= nil then
      nb_signs = nb_signs + 1
    else
      nb_others = nb_others + 1
    end
  end

  -- Display the statistics
  info = string.format('Chars: %d\nDigits: %d\nSpaces: %d\nSigns: %d\nOthers: %d\nTotal: %d', nb_chars, nb_digits, nb_spaces, nb_signs, nb_others, nbc)
  ui.dialogs.msgbox{title = 'Statistics',
                    text = info, 
                    informative_text = 'Statistics on the '..infotext,
                    icon = 'dialog-information', 
                    button1 = 'OK', 
                    button2 = nil, 
                    button3 = nil}
end
