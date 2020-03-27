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
events.connect(events.LEXER_LOADED, function(lexer)
  if lexer == 'markdown' or
     lexer == 'text' then
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
  function (code, shift, control, alt, meta, caps_lock)
    if buffer.property['key.special.square'] == 'true' and code == 178 then -- the tiny "2" (square)
      if not shift and 
         not control and 
         not alt and
         not meta and
         not caps_lock then
        buffer:replace_sel('`')
        return true
      elseif shift and 
         not control and 
         not alt and
         not meta and
         not caps_lock then
        buffer:replace_sel('```')
        return true
      elseif not shift and 
         control and 
         not alt and
         not meta and
         not caps_lock then
        local quote_start, quote_end = Util.get_current_sel_pos()
        if quote_start < quote_end then
          Util.quote_text('`', quote_start, quote_end)
        end
        return true
      end
    end
  end)
