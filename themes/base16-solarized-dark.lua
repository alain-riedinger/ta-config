-- Solarized theme for Textadept
-- Theme author: Ethan Schoonover (http://ethanschoonover.com/solarized)
-- Base16 (https://github.com/chriskempson/base16)
-- Build with Base16 Builder (https://github.com/chriskempson/base16-builder)
-- Repository: https://github.com/rgieseke/ta-themes
--
-- For TextAdept v11 migration, inspired by:
-- https://github.com/rgieseke/base16-textadept/blob/master/themes/base16-solarized-dark.lua
-- and also by default "dark" theme
-- "C:\Tools\TextAdept\themes\dark.lua"

local view, colors, styles = view, lexer.colors, lexer.styles

-- Definition of Colors a la "Solarized Dark"
colors.base00 = 0x362b00   -- base03
colors.base01 = 0x423607   -- base02
colors.base02 = 0x756e58   -- base01
colors.base03 = 0x837b65   -- base00
colors.base04 = 0x969483   -- base0
colors.base05 = 0xa1a193   -- base1
colors.base06 = 0xd5e8ee   -- base2
colors.base07 = 0xe3f6fd   -- base3
colors.base08 = 0x2f32dc   -- red
colors.base09 = 0x164bcb   -- orange
colors.base0A = 0x0089b5   -- yellow
colors.base0B = 0x009985   -- green
colors.base0C = 0x98a12a   -- cyan
colors.base0D = 0xd28b26   -- blue
colors.base0E = 0xc4716c   -- violet
colors.base0F = 0x8236d3   -- magenta

-- Supercharge Definition of colors as in official TextAdept themes
-- (see TextAdept install dirs in TextAdept\themes)
-- Greyscale colors.
colors.dark_black = 0x000000
colors.black = colors.base00
colors.light_black = colors.base01
colors.grey_black = colors.base02
colors.dark_grey = colors.base03
colors.grey = colors.base04
colors.light_grey = colors.base04
colors.grey_white = colors.base05
colors.dark_white = colors.base06
colors.white = colors.base07
colors.light_white = 0xFFFFFF

-- Dark colors.
colors.dark_red = colors.base08
colors.dark_yellow = colors.base0A
colors.dark_green = colors.base0B
colors.dark_teal = colors.base0C
colors.dark_purple = colors.base0E
colors.dark_orange = colors.base09
colors.dark_pink = colors.base0F
colors.dark_lavender = colors.base0E
colors.dark_blue = colors.base0D

-- Normal colors.
colors.red = colors.base08
colors.yellow = colors.base0A
colors.green = colors.base0B
colors.teal = colors.base0C
colors.purple = colors.base0E
colors.orange = colors.base09
colors.pink = colors.base0F
colors.lavender = colors.base0E
colors.blue = colors.base0D

-- Light colors.
colors.light_red = colors.base08
colors.light_yellow = colors.base0A
colors.light_green = colors.base0B
colors.light_teal = colors.base0C
colors.light_purple = colors.base0E
colors.light_orange = colors.base09
colors.light_pink = colors.base0F
colors.light_lavender = colors.base0E
colors.light_blue = colors.base0D

-- Ugly workaround because of non persisting default colors, in lexer script
-- The default colors are reverted to "light.lua" values
-- The UPPERCASE colors are correctly set
-- Store here all the colors used by the custom lexers (or the others)
colors.BLACK      = colors.black
colors.BLUE       = colors.blue
colors.YELLOW     = colors.yellow
colors.GREY_BLACK = colors.grey_black
colors.GREEN      = colors.green
colors.RED        = colors.red
colors.TEAL       = colors.teal
colors.ORANGE     = colors.orange
-- Workaround ends here

-- Default font.
if not font then
  font = WIN32 and 'Courier New' or OSX and 'Monaco' or
    'Bitstream Vera Sans Mono'
end
if not size then size = not OSX and 10 or 12 end

-- Predefined styles.
styles.default = {
  font = font, size = size, fore = colors.base05, back = colors.base00
}
styles.line_number = {fore = colors.base02, back = colors.base00}
--styles.control_char =
styles.indent_guide = {fore = colors.base03}
styles.call_tip = {fore = colors.base02, back = colors.base07}
styles.fold_display_text = {fore = colors.base02}
styles.bracelight = {fore = colors.base0C, underlined = true}
styles.bracebad = {fore = colors.base08}

-- Token styles.
styles.class = {fore = colors.base0A}
styles.comment = {fore = colors.base03}
styles.constant = {fore = colors.base09}
styles.embedded = {fore = colors.base0F, back = colors.base01}
styles.error = {fore = colors.base08, italics = true}
styles['function'] = {fore = colors.base09}
styles.identifier = {}
styles.keyword = {fore = colors.base0D}
styles.label = {fore = colors.base09}
styles.number = {fore = colors.base0C}
styles.operator = {fore = colors.base0E}
styles.preprocessor = {fore = colors.base0A}
styles.regex = {fore = colors.base0C}
styles.string = {fore = colors.base0B}
styles.type = {fore = colors.base0E}
styles.variable = {fore = colors.base0D}
styles.whitespace = {}

-- Multiple Selection and Virtual Space
--view.additional_sel_alpha =
--view.additional_sel_fore =
--view.additional_sel_back =
--view.additional_caret_fore =

-- Caret and Selection Styles.
view:set_sel_fore(true, colors.base06)
view:set_sel_back(true, colors.base02)
--view.sel_alpha =
view.caret_fore = colors.base05
view.caret_line_back = colors.base01
--view.caret_line_back_alpha =

-- Fold Margin.
view:set_fold_margin_color(true, colors.base00)
view:set_fold_margin_hi_color(true, colors.base00)

-- Markers.
--view.marker_fore[textadept.bookmarks.MARK_BOOKMARK] = colors.base00
view.marker_back[textadept.bookmarks.MARK_BOOKMARK] = colors.base0B
--view.marker_fore[textadept.run.MARK_WARNING] = colors.base00
view.marker_back[textadept.run.MARK_WARNING] = colors.base0E
--view.marker_fore[textadept.run.MARK_ERROR] = colors.base00
view.marker_back[textadept.run.MARK_ERROR] = colors.base08
for i = buffer.MARKNUM_FOLDEREND, buffer.MARKNUM_FOLDEROPEN do -- fold margin
  view.marker_fore[i] = colors.base00
  view.marker_back[i] = colors.base03
  view.marker_back_selected[i] = colors.base02
end

-- Indicators.
view.indic_fore[ui.find.INDIC_FIND] = colors.base09
view.indic_alpha[ui.find.INDIC_FIND] = 128
view.indic_fore[textadept.editing.INDIC_BRACEMATCH] = colors.base06
view.indic_fore[textadept.editing.INDIC_HIGHLIGHT] = colors.base07
view.indic_alpha[textadept.editing.INDIC_HIGHLIGHT] = 128
view.indic_fore[textadept.snippets.INDIC_PLACEHOLDER] = colors.base04

-- Call tips.
view.call_tip_fore_hlt = colors.base06

-- Long Lines.
view.edge_color = colors.base01
