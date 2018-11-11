--[[--------------------------------------------------
Switches to distraction free layout
and also back
[Distraction Free Mode](https://foicica.com/wiki/distraction-free-mode)
=> implémentation officielle
--]]----------------------------------------------------

DistractionFree = {}

local distraction_free = false
local menubar = textadept.menu.menubar
local margin_widths = {}
local update_ui_hook
local maximized = ui.maximized
--[[
Switches to distraction free mode, and back
]]
function DistractionFree.toggle()
  local buffer = buffer
  if not distraction_free then
    textadept.menu.menubar = nil
    for i = 0, 4 do
      margin_widths[i] = buffer.margin_width_n[i]
      buffer.margin_width_n[i] = 0
    end
    buffer.h_scroll_bar = false
    buffer.v_scroll_bar = false
    update_ui_hook = events.connect(events.UPDATE_UI,
                                    function()
      ui.statusbar_text, ui.bufstatusbar_text = '', ''
    end)
    events.emit(events.UPDATE_UI)
    ui.maximized = true
  else
    textadept.menu.menubar = menubar
    for i = 0, 4 do
      buffer.margin_width_n[i] = margin_widths[i]
    end
    buffer.h_scroll_bar = true
    buffer.v_scroll_bar = true
    events.disconnect(update_ui_hook)
    ui.maximized = maximized
  end
  distraction_free = not distraction_free
end
