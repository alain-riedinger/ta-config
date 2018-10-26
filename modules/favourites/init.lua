--[[------------------------------------------------------------------------------
Handle favourite files
A popup lets the user choose among listed files
Stored on Windows in: %USERPROFILE%\TextAdept.favs
]]

Favourites = {}

-- Retrieve the TextAdept user home path (seems to be set by default)
--if not _USERHOME then
  --_USERHOME = os.getenv(not WIN32 and 'HOME' or 'USERPROFILE')..'/.textadept'
--end

-- Read favourite files
function read_favs_file()
  local favs_file = _USERHOME.."\\textadept.favs"
  local f1 = io.open(favs_file)
  local favs = {}
  local i = 1
  if f1 then
    for line in f1:lines() do
      local l=line
      favs[i] = l
      i = i + 1
    end
    io.close(f1)
  end
  return favs
end

-- Select Favourite
function Favourites.select_favourite()
  local favs = read_favs_file()
  if #favs > 0 then
    local options = {
      title = 'Favourites',
      informative_text = 'Select the file to open',
      columns = {'Path'},
      items = {}
    }
    -- Add the paths of favourite files to the option
    for k,v in pairs(favs) do
      table.insert(options["items"], v)
    end
    -- Display filtered dialog for user input
    local button, idx = ui.dialogs.filteredlist(options)
    if button == 1 and idx then
      io.open_file(options["items"][idx], nil)
    end
  end
end
