--[[--------------------------------------------------
Switches to distraction free layout
and also back
[DistractionFreeMode · orbitalquark/textadept Wiki · GitHub](https://github.com/orbitalquark/textadept/wiki/DistractionFreeMode)
=> implémentation officielle
--]]----------------------------------------------------

DistractionFree = {}

local distraction_free = false
local menubar = textadept.menu.menubar
local tab_bar = ui.tabs
local margin_widths = {}
local maximized = ui.maximized

function clean_statusbar ()
    ui.statusbar_text = '' 
    ui.buffer_statusbar_text = ''
end

--[[
Switches to distraction free mode, and back
]]
function DistractionFree.toggle()
    if not distraction_free then
        textadept.menu.menubar = nil  -- Remove menu bar
        ui.tabs = false  -- Remove the tab bar
        -- Remove any margins, e.g. line numbers, bookmarks
        for i = 1, view.margins do
          margin_widths[i] = view.margin_width_n[i]
          view.margin_width_n[i] = 0
        end
       -- Disable scroll bars
       view.h_scroll_bar = false
       view.v_scroll_bar = false
       -- Force the statusbar to always be blank
       events.connect(events.UPDATE_UI, clean_statusbar)
       events.emit(events.UPDATE_UI, 1)
       ui.maximized = true  -- Maximise the screen
    else  -- Restore old state.
        textadept.menu.menubar = menubar
        ui.tabs = tab_bar
        for i = 1, view.margins do
          view.margin_width_n[i] = margin_widths[i]
        end
        view.h_scroll_bar = true
        view.v_scroll_bar = true
        events.disconnect(events.UPDATE_UI, clean_statusbar)
        events.emit(events.UPDATE_UI, 1)
        ui.maximized = maximized
    end
    distraction_free = not distraction_free
end
