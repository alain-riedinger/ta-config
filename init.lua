--[[

(!) to reload the init.lua script on the fly, do:
- hit Ctrl+E, ie.: "Tools", "Command Entry"
- type `reset()`
- hit Return

[Textadept 10.1 Manual](https://foicica.com/textadept/manual.html)
[Textadept 10.0 API](https://foicica.com/textadept/api.html)
=> Official TextAdept documentation

[Lua cheatsheet](https://devhints.io/lua)
=> Lua cheatsheet
]]

--[[---------------------------------------------------------------------------------------
Require the other modules
]]
require('util')
require('ctrl_tab_mru')
require('favourites')
require('french_helpers')
require('highlighting')
require('color_hint')
require('search')
require('distraction_free')
--require('ctags')

--[[---------------------------------------------------------------------------------------
Set theming
]]
if not CURSES then 
  buffer:set_theme('base16-solarized-dark', {
    font = "Consolas",
    fontsize = 12
  }) 
end

--[[---------------------------------------------------------------------------------------
Set properties
]]
-- Global properties for behaviour management
buffer.property['key.special.square'] = 'false'
buffer.property['highlighting.identical.text'] = 1
buffer.property['highlighting.color.hint'] = 1

-- Editor settings
buffer.caret_style = buffer.CARETSTYLE_LINE
buffer.caret_width = 2
buffer.caret_fore = 0x0000FF
buffer.caret_line_visible = true
--buffer.caret_line_visible_always = true
--buffer.caret_line_back = 0x333333
--buffer.caret_line_back_alpha =
--buffer.caret_period = 0
--buffer.caret_style = c.CARETSTYLE_BLOCK
--buffer.caret_sticky = c.SC_CARETSTICKY_ON

-- Adapt auto-pairs to french language
textadept.editing.auto_pairs = {[40] = ')', [91] = ']', [123] = '}', [34] = '"'}
textadept.editing.typeover_chars = {[41] = 1, [93] = 1, [125] = 1, [34] = 1}

--[[---------------------------------------------------------------------------------------
Special behaviours for markdown and text lexers
]]
events.connect(events.LEXER_LOADED, function(lexer)
  if lexer == 'markdown' or
     lexer == 'text' then
    -- Request adapted behaviour for square key
    buffer.property['key.special.square'] = 'true'
    
    -- Activate wrap mode
    buffer.wrap_mode = buffer.WRAP_WHITESPACE
    buffer.wrap_visual_flags = buffer.WRAPVISUALFLAG_MARGIN
  else
    -- Set normal behaviour for square key
    buffer.property['key.special.square'] = 'false'

    -- Reset wrap mode
    buffer.wrap_mode = buffer.WRAP_NONE
    buffer.wrap_visual_flags = buffer.WRAPVISUALFLAG_NONE
    end
end)

--[[
Adaptation to french keyboard
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
      end
    end
  end)

--[[
Markdown facilities:
- a double click on a link
]]
events.connect(events.DOUBLE_CLICK,
  function (position, line, modifiers)
    if buffer.get_lexer(buffer, false) == 'markdown' then
      if Util.land(modifiers, buffer.MOD_CTRL) == buffer.MOD_CTRL then 
        local style = buffer.style_at[buffer.current_pos]
        --local text = string.format("%s (%d)", buffer.style_name[style], style)
        --Util.status(text)
        if buffer.style_name[style] == 'link' then
          local pos = buffer.current_pos
          -- Search for trailing )
          repeat
            local char = buffer:text_range(pos, buffer:position_after(pos))
            pos = pos + 1
          until char == ')'
          local pos_trailing = pos - 1
          -- Search for leading (
          repeat
            local char = buffer:text_range(pos, buffer:position_after(pos))
            pos = pos - 1
          until char == '('
          local pos_leading = pos + 1
          -- Get the URL of the link
          local url = buffer:text_range(pos_leading + 1, pos_trailing)
          Util.status(url)
          --[lua-users wiki: Scite Open Url](http://lua-users.org/wiki/SciteOpenUrl)
          if string.match(url, "^http[s]*://.+") or
             string.match(url, "^ftp://.+") or
             string.match(url, "^www%..+") then
            --os.execute("x-www-browser "..url.." &")
            --os.execute("C:\\Program Files\\Mozilla Firefox\\firefox.exe "..url.." &")
            os.execute('start /b "" "'..url..'"')
          end
        end
      end
    end
  end)
  
--[[---------------------------------------------------------------------------------------
Customizations of user inputs:
- menus
- shorcuts
]]

-- Ctrl+F : searches for current word, if any
keys['cf'] = function()
  Search.preload_search_ui()
end

-- Ctrl+F3 : searches for next occurence of current word, if any
-- Ctrl+Shift+F3 : searches for previous occurence of current word, if any
keys['cf3'] = function()
  Search.search_current_word(true)
end
keys['csf3'] = function()
  Search.search_current_word(false)
end

-- F11 : switch to and from distraction free mode
keys['f11'] = function()
  DistractionFree.toggle()
end

-- Ctrl+" : sets the current selection (if any) or the current word between quotes
keys['c"'] = function()
  if buffer.get_lexer(buffer, false) == 'markdown' then
    local sel_start = buffer.selection_start
    local sel_end = buffer.selection_end
    if sel_start < sel_end then
      -- Quote the current selection
      Util.quote_text(sel_start, sel_end)
    else
      -- Quote the current word if any
      local current_pos = buffer.current_pos
      local word_end   = buffer.word_end_position(buffer, current_pos, true)
      local word_start = buffer.word_start_position(buffer, current_pos, true)
      if word_start < word_end then
        Util.quote_text(word_start, word_end)
      end
    end
  end
end

-- Sample shortcut: here for Ctrl+F12
keys['cf12'] = function()
  --ui.dialogs.filteredlist{title = 'Title', columns = {'Foo', 'Bar'}, items = {'a', 'b', 'c', 'd'}} 
  --ui.statusbar_text = tostring(Util.get_current_word())
  --Util.editor_mark_text_alpha(4, buffer.current_pos, 10, '0x00AA00', 30, 192)
  --Util.editor_mark_text_alpha(5, buffer.current_pos, 10, '0x0000AA', 30, 192)
  --Util.is_color('function')
  --Util.is_color('0xFFEEDD')
  Util.is_color('0xBBGGRR')
end

-- Example of menu bar extension
local SEPARATOR = {''}
local my_tools_menu = {
  title = 'My Tools',
  {'Favourites...', function() Favourites.select_favourite() end},
  {'Item 2', function() local j = 1 end}
}
local tools = textadept.menu.menubar[_L['_Tools']]
tools[#tools + 1] = SEPARATOR
tools[#tools + 1] = my_tools_menu

-- Example of tab context menu
local my_tab_context_menu = {
  title = 'My Tab Context',
  {'Item 1', function() local i = 1 end},
  {'Item 2', function() local j = 1 end}
}
local tab_context = textadept.menu.tab_context_menu
tab_context[#tab_context + 1] = SEPARATOR
tab_context[#tab_context + 1] = my_tab_context_menu

-- Example of context menu
local my_context_menu = {
  title = 'My Context',
  {'Item 1', function() local i = 1 end},
  {'Item 2', function() local j = 1 end}
}
local context = textadept.menu.context_menu
context[#context + 1] = SEPARATOR
context[#context + 1] = my_context_menu

--[[
Fake function for testing menus and shortcuts actions
]]
function test()
  Util.debug('test - BEGIN')
  Util.debug('test - END')
end
