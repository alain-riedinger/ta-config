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
--
-- For TextAdept v12 migration, inspired by default "dark" theme
-- "C:\Tools\TextAdept\themes\dark.lua"

local view, colors, styles = view, view.colors, view.styles

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
colors.black = colors.base00
colors.light_black = colors.base01
colors.dark_grey = colors.base03
colors.grey = colors.base04 -- unused
colors.light_grey = colors.base04
colors.white = colors.base07 -- unused
colors.dark_black = 0x000000
colors.light_white = 0xC0C0C0
colors.grey_black = colors.base02
colors.grey_white = colors.base05
colors.dark_white = colors.base06

-- Normal colors.
colors.red = colors.base08
colors.orange = colors.base09
colors.yellow = colors.base0A
colors.lime = 0x00CC99
colors.green = colors.base0B
colors.teal = colors.base0C
colors.blue = colors.base0D
colors.violet = colors.base0E
colors.purple = colors.base0E
colors.magenta = colors.base0F

-- Default font.
if not font then font = WIN32 and 'Consolas' or OSX and 'Monaco' or 'Monospace' end
if not size then size = not OSX and 10 or 12 end

-- Predefined styles.
styles[view.STYLE_DEFAULT] = {
	font = font, size = size, fore = colors.light_grey, back = colors.black
}
styles[view.STYLE_LINENUMBER] = {fore = colors.dark_grey, back = colors.black}
styles[view.STYLE_BRACELIGHT] = {fore = colors.blue, bold = true}
styles[view.STYLE_BRACEBAD] = {fore = colors.red}
-- styles[view.STYLE_CONTROLCHAR] = {}
styles[view.STYLE_INDENTGUIDE] = {fore = colors.light_black}
styles[view.STYLE_CALLTIP] = {fore = colors.light_grey}
styles[view.STYLE_FOLDDISPLAYTEXT] = {fore = colors.dark_grey, back = colors.light_black}

-- Tag styles.
styles[lexer.ANNOTATION] = {fore = colors.magenta}
styles[lexer.ATTRIBUTE] = {fore = colors.violet}
styles[lexer.BOLD] = {bold = true}
styles[lexer.CLASS] = {fore = colors.yellow}
styles[lexer.CODE] = {fore = colors.dark_grey, eol_filled = true}
styles[lexer.COMMENT] = {fore = colors.dark_grey}
-- styles[lexer.CONSTANT] = {}
styles[lexer.CONSTANT_BUILTIN] = {fore = colors.purple}
styles[lexer.EMBEDDED] = {fore = colors.purple}
styles[lexer.ERROR] = {fore = colors.red}
-- styles[lexer.FUNCTION] = {}
styles[lexer.FUNCTION_BUILTIN] = {fore = colors.orange}
-- styles[lexer.FUNCTION_METHOD] = {}
styles[lexer.HEADING] = {fore = colors.orange}
-- styles[lexer.IDENTIFIER] = {}
styles[lexer.ITALIC] = {italic = true}
styles[lexer.KEYWORD] = {fore = colors.blue}
styles[lexer.LABEL] = {fore = colors.magenta}
styles[lexer.LINK] = {underline = true}
styles[lexer.LIST] = {fore = colors.teal}
styles[lexer.NUMBER] = {fore = colors.teal}
-- styles[lexer.OPERATOR] = {}
styles[lexer.PREPROCESSOR] = {fore = colors.magenta}
styles[lexer.REFERENCE] = {underline = true}
styles[lexer.REGEX] = {fore = colors.lime}
styles[lexer.STRING] = {fore = colors.green}
styles[lexer.TAG] = {fore = colors.blue}
styles[lexer.TYPE] = {fore = colors.violet}
styles[lexer.UNDERLINE] = {underline = true}
-- styles[lexer.VARIABLE] = {}
styles[lexer.VARIABLE_BUILTIN] = {fore = colors.yellow}
-- styles[lexer.WHITESPACE] = {}

-- CSS.
styles.property = styles[lexer.ATTRIBUTE]
-- styles.pseudoclass = {}
-- styles.pseudoelement = {}
-- Diff.
styles.addition = {fore = colors.green}
styles.deletion = {fore = colors.red}
styles.change = {fore = colors.yellow}
-- HTML.
styles.tag_unknown = styles.tag .. {italic = true}
styles.attribute_unknown = styles.attribute .. {italic = true}
-- Latex, TeX, and Texinfo.
styles.command = styles[lexer.KEYWORD]
styles.command_section = styles[lexer.HEADING]
styles.environment = styles[lexer.TYPE]
styles.environment_math = styles[lexer.NUMBER]
-- Makefile.
-- styles.target = {}

-- Markdown.
styles.hr = {fore = colors.black, back = colors.orange, eol_filled = true}
styles[lexer.HEADING..'.h6'] = {fore = colors.orange}
styles[lexer.HEADING..'.h5'] = {fore = colors.orange}
styles[lexer.HEADING..'.h4'] = {fore = colors.orange, italic = true}
styles[lexer.HEADING..'.h3'] = {fore = colors.orange, underline = true}
styles[lexer.HEADING..'.h2'] = {fore = colors.orange, bold = true}
styles[lexer.HEADING..'.h1'] = {fore = colors.orange, bold = true, underline = true}
styles[lexer.LIST] = {fore = colors.orange}
styles[lexer.CODE] = {fore = colors.teal}
styles[lexer.LINK] = {fore = colors.blue, underline = true}
styles[lexer.REFERENCE] = styles[lexer.LINK]
styles[lexer.STRING] = {fore = colors.green}
styles['image'] = styles[lexer.LINK]
styles[lexer.BOLD] = {fore = colors.yellow, bold = true}
styles[lexer.ITALIC] = {fore = colors.yellow, italic = true}
styles['quoted'] = {fore = colors.yellow}
styles['strikeout'] = {fore = colors.grey_black}
styles['conclusion'] = {fore = colors.green, bold = true}
styles['action'] = {fore = colors.teal, bold = true}
styles['warning'] = {fore = colors.red, bold = true}
styles['idea'] = {fore = colors.teal, bold = true}
styles['todo'] = {fore = colors.orange, bold = true}
styles['done'] = {fore = colors.teal, bold = true}

-- Python.
styles.keyword_soft = {}
-- XML.
-- styles.cdata = {}
-- YAML.
styles.error_indent = {back = colors.red}

-- Element colors.
view.element_color[view.ELEMENT_SELECTION_TEXT] = colors.white
view.element_color[view.ELEMENT_SELECTION_BACK] = colors.grey_black
view.element_color[view.ELEMENT_SELECTION_ADDITIONAL_BACK] = colors.light_black
view.element_color[view.ELEMENT_SELECTION_SECONDARY_BACK] = colors.light_black
view.element_color[view.ELEMENT_SELECTION_INACTIVE_BACK] = colors.light_black
view.element_color[view.ELEMENT_SELECTION_INACTIVE_ADDITIONAL_BACK] = colors.light_black
view.element_color[view.ELEMENT_CARET] = colors.red
-- view.element_color[view.ELEMENT_CARET_ADDITIONAL] =
if view ~= ui.command_entry then
	view.element_color[view.ELEMENT_CARET_LINE_BACK] = colors.light_black | 0x80000000
end
view.caret_line_layer = view.LAYER_UNDER_TEXT

-- Fold Margin.
view:set_fold_margin_color(true, colors.black)
view:set_fold_margin_hi_color(true, colors.black)

-- Markers.
view.marker_back[textadept.bookmarks.MARK_BOOKMARK] = colors.blue
view.marker_back[textadept.run.MARK_WARNING] = colors.yellow
view.marker_back[textadept.run.MARK_ERROR] = colors.red
for i = view.MARKNUM_FOLDEREND, view.MARKNUM_FOLDEROPEN do -- fold margin
	view.marker_fore[i] = colors.black
	view.marker_back[i] = colors.dark_grey
	view.marker_back_selected[i] = colors.light_grey
end

-- Indicators.
view.indic_fore[ui.find.INDIC_FIND] = colors.yellow
view.indic_alpha[ui.find.INDIC_FIND] = 0x80
view.indic_fore[textadept.editing.INDIC_HIGHLIGHT] = colors.orange
view.indic_alpha[textadept.editing.INDIC_HIGHLIGHT] = 0x80
view.indic_fore[textadept.snippets.INDIC_PLACEHOLDER] = colors.light_grey
view.indic_fore[textadept.run.INDIC_WARNING] = colors.yellow
view.indic_fore[textadept.run.INDIC_ERROR] = colors.red

-- Call tips.
view.call_tip_fore_hlt = colors.blue

-- Long Lines.
view.edge_color = colors.light_black

-- Find & replace pane entries.
ui.find.entry_font = font .. ' ' .. size

