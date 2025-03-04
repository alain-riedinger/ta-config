--[[---------------------------------------------------------------------------------------
Adaptations to french language
- keyboard helpers
- auto-pairs helpers
]]

--[[---------------------------------------------------------------------------------------
Adapt auto-pairs to french language
]]
textadept.editing.auto_pairs = {[40] = ')', [91] = ']', [123] = '}', [34] = '"'}
textadept.editing.typeover_chars = {[41] = 1, [93] = 1, [125] = 1, [34] = 1}

--[[---------------------------------------------------------------------------------------
Only change key for markdown and text
]]
events.connect(events.BUFFER_AFTER_SWITCH, function()
  if buffer.lexer_language == 'markdown' or
     buffer.lexer_language == 'text' then
    buffer.property['key.special.square'] = 'true'
  else
    buffer.property['key.special.square'] = 'false'
  end
end)

--[[
Adaptation to french keyboard 
(some easy QWERTY characters are a real pain in AZERTY keyboards)
- "²" key transformed to back quote
]]
events.connect(events.KEYPRESS, 
  function (key)
	-- Key character is the last of the string
    if buffer.property['key.special.square'] == 'true' and 
	   string.byte(string.sub(key,string.len(key))) == 178 then -- the tiny "2" (square)
	  -- Beware: shift has no effect on square key and is not detected !
	  if string.sub(key, 0, string.len('ctrl')) == 'ctrl' then
	    -- Backquote current word or selection
        local quote_start, quote_end = Util.get_current_sel_pos()
        if quote_start < quote_end then
          Util.quote_text('`', quote_start, quote_end)
        end
	  else
	    -- Display a backquote
  	    buffer:replace_sel('`')
	  end
	  return true
	end
  end)
