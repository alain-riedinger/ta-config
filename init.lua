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
require('french_helpers')
require('ctrl_tab_mru')
require('favourites')
require('text_format')
require('highlighting')
require('distraction_free')
require('color_hint')
require('search')
require('enhanced')

--[[---------------------------------------------------------------------------------------
Set theming
]]
-- Adjust the default theme's font and size.
if not CURSES then
  view:set_theme('base16-solarized-dark', {
	font = 'Consolas', 
	size = 12
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
view.caret_style = buffer.CARETSTYLE_LINE
view.caret_width = 2
-- caret color is now defined in theme
-- view.caret_line_visible = true
-- view.caret_line_visible_always = true
-- view.caret_line_back = 0x333333
-- view.caret_line_back_alpha = 
-- view.caret_period = 0

-- Adapt auto-pairs to french language
textadept.editing.auto_pairs = {[40] = ')', [91] = ']', [123] = '}', [34] = '"'}
textadept.editing.typeover_chars = {[41] = 1, [93] = 1, [125] = 1, [34] = 1}

--[[---------------------------------------------------------------------------------------
Snippets are located appart, for clarity's sake
]]
require('snippets')

--[[---------------------------------------------------------------------------------------
Special behaviours depending on lexers
]]
events.connect(events.BUFFER_AFTER_SWITCH, function()
  -- Special behaviours for markdown and text lexers
  if buffer.lexer_language == 'markdown' or
     buffer.lexer_language == 'text' then
    -- Request adapted behaviour for square key
    buffer.property['key.special.square'] = 'true'
    
    -- Activate wrap mode
    view.wrap_mode = view.WRAP_WHITESPACE
    view.wrap_visual_flags = view.WRAPVISUALFLAG_MARGIN
  else
    -- Set normal behaviour for square key
    buffer.property['key.special.square'] = 'false'

    -- Reset wrap mode
    view.wrap_mode = view.WRAP_NONE
    view.wrap_visual_flags = view.WRAPVISUALFLAG_NONE
  end

  -- Special behaviours for markdown
  if buffer.lexer_language == 'markdown' then
    -- Add a context menu for markdown tables formatting
    local context = textadept.menu.context_menu
	local sub = context['My Context']
	if sub['Tablify'] == nil then
	  table.insert(sub, 1, {'Tablify', function() TextFormat.tablify() end})
	  table.insert(sub, 2, {''})
	end
  end
end)


--[[---------------------------------------------------------------------------------------
Customizations of user inputs:
- shorcuts
]]

-- Sample shortcut: here for Ctrl+F12
keys['ctrl+f12'] = function()
  Util.debug('Shortcut sample!!!')
end

-- Ctrl+F : searches for current word, if any
keys['ctrl+f'] = function()
  Search.preload_search_ui()
end

-- No more by default since release 12.x
-- F3 : search for the next occurence
-- Shift+F3 : search for the previous occurence
keys['f3'] = function()
  Util.trace("F3")
  ui.find.find_next()
end
keys['shift+f3'] = function()
  Util.trace("Shift+F3")
  ui.find.find_prev()
end

-- Ctrl+F3 : searches for next occurence of current word, if any
-- Ctrl+Shift+F3 : searches for previous occurence of current word, if any
keys['ctrl+f3'] = function()
  Search.search_current_word(true)
end
keys['ctrl+shift+f3'] = function()
  Search.search_current_word(false)
end

-- F11 : switch to and from distraction free mode
keys['f11'] = function()
  DistractionFree.toggle()
end

-- Ctrl+" : sets the current selection (if any) or the current word between quotes
keys['ctrl+"'] = function()
  if buffer.get_lexer(buffer, false) == 'markdown' then
    local quote_start, quote_end = Util.get_current_sel_pos()
    if quote_start < quote_end then
      Util.quote_text('"', quote_start, quote_end)
    end
  end
end

-- Ctrl+* : sets the current selection (if any) or the current word between stars
keys['ctrl+*'] = function()
  if buffer.get_lexer(buffer, false) == 'markdown' then
    local quote_start, quote_end = Util.get_current_sel_pos()
    if quote_start < quote_end then
      Util.quote_text('*', quote_start, quote_end)
    end
  end
end

-- Ctrl+_ : sets the current selection (if any) or the current word between underscores
keys['ctrl+_'] = function()
  if buffer.get_lexer(buffer, false) == 'markdown' then
    local quote_start, quote_end = Util.get_current_sel_pos()
    if quote_start < quote_end then
      Util.quote_text('_', quote_start, quote_end)
    end
  end
end

-- Disable weird AltGr false behavior on Windows
if WIN32 then
  keys['ctrl+alt+|'] = nil		-- for ALtGr |  6
  keys['ctrl+alt+_'] = nil		-- for ALtGr \  8
end

-- Ctrl+D : duplicate current line
keys['ctrl+D'] = nil		-- Don't like the default key ctrl+shift+d, better ctrl+d like all other editors
keys['ctrl+d'] = function()
  buffer:selection_duplicate()
end


--[[---------------------------------------------------------------------------------------
Customizations of user inputs:
- menus
]]

-- Example of menu bar extension
local SEPARATOR = {''}
local my_tools_menu = {
  title = 'My Tools',
  {'Favourites...', function() Favourites.select_favourite() end},
  {'Item 2', function() local j = 1 end}
}
local tools = textadept.menu.menubar[_L['Tools']]
tools[#tools + 1] = SEPARATOR
tools[#tools + 1] = my_tools_menu

-- Example of tab context menu
local my_tab_context_menu = {
  title = 'My Tab Context',
  {'Copy path', function() 
      if WIN32 then
        buffer:copy_text(buffer.filename:match("(.*\\)"))
	  else
        buffer:copy_text(buffer.filename:match("(.*/)"))
	  end
	end},
  {'Item 2', function() local j = 1 end}
}
local tab_context = textadept.menu.tab_context_menu
tab_context[#tab_context + 1] = SEPARATOR
tab_context[#tab_context + 1] = my_tab_context_menu

-- Example of context menu
local my_context_menu = {
  title = 'My Context',
  {'Text Stats...', function() Enhanced.text_stats() end},
  {'Item 2', function() local j = 1 end}
}
local context = textadept.menu.context_menu
context[#context + 1] = SEPARATOR
context[#context + 1] = my_context_menu

--[[
Markdown facilities:
- a double click on a link
]]
events.connect(events.DOUBLE_CLICK, function (position, line, modifiers)
  if buffer.lexer_language == 'markdown' then
    if Util.land(modifiers, view.MOD_CTRL) == view.MOD_CTRL then 
      local style = buffer.style_at[buffer.current_pos]
      local text = string.format("%s (%d)", buffer:name_of_style(style), style)
      if buffer:name_of_style(style) == 'link' then
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
		  if WIN32 then
            os.execute('start /b "" "'..url..'"')
		  end
        end
      end
    end
  end
end)
