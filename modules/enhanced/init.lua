--[[--------------------------------------------------
Several helpers that enhance the day to day usage of TextAdept editor
Some sources of inspiration:
[reback00/ta-config: Config to customize Textadept to act more like Atom/$ublime text - NotABug.org: Free code hosting](https://notabug.org/reback00/ta-config/src/master/init.lua)

--]]----------------------------------------------------


--[[ 
Shows total number of selected characters in the statusbar
]]
events.connect(events.UPDATE_UI, function()
  if buffer.UPDATE_SELECTION ~= 0 then
		local selcount = 0
		for i = 1, buffer.selections do
			selcount = selcount + (buffer.selection_n_end[i] - buffer.selection_n_start[i])
		end
		if selcount > 0 then
			ui.statusbar_text = 'Chars: '..selcount
		else
			ui.statusbar_text = ''
		end
  end
end)
