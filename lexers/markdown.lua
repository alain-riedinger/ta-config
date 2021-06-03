-- Copyright 2006-2018 Mitchell mitchell.att.foicica.com. See License.txt.
-- Markdown LPeg lexer.
--[[
[An introduction to Parsing Expression Grammars with LPeg](http://leafo.net/guides/parsing-expression-grammars.html)
]]

local lexer = require('lexer')
local token, word_match = lexer.token, lexer.word_match
local P, R, S = lpeg.P, lpeg.R, lpeg.S

local lex = lexer.new('markdown')

-- Block elements.
lex:add_rule('header',
             token('h6', lexer.starts_line('######') * lexer.nonnewline^0) +
             token('h5', lexer.starts_line('#####') * lexer.nonnewline^0) +
             token('h4', lexer.starts_line('####') * lexer.nonnewline^0) +
             token('h3', lexer.starts_line('###') * lexer.nonnewline^0) +
             token('h2', lexer.starts_line('##') * lexer.nonnewline^0) +
             token('h1', lexer.starts_line('#') * lexer.nonnewline^0))
lex:add_style('h6', {fore = lexer.colors.orange})
lex:add_style('h5', {fore = lexer.colors.orange})
lex:add_style('h4', {fore = lexer.colors.orange, italics = true })
lex:add_style('h3', {fore = lexer.colors.orange, underlined = true})
lex:add_style('h2', {fore = lexer.colors.orange, bold = true})
lex:add_style('h1', {fore = lexer.colors.orange, bold = true, underlined = true})

lex:add_rule('blockquote',
             token(lexer.STRING,
                   lpeg.Cmt(lexer.starts_line(S(' \t')^0 * '>'),
                            function(input, index)
                              local _, e = input:find('\n[ \t]*\r?\n', index)
                              return (e or #input) + 1
                            end)))

lex:add_rule('list', token('list', lexer.starts_line(S(' \t')^0 * (S('*+-') +
                                                     R('09')^1 * '.')) *
                                   S(' \t')))
lex:add_style('list', lexer.STYLE_CONSTANT)

local hspace = S('\t\v\f\r ')
local blank_line = '\n' * hspace^0 * ('\n' + P(-1))

lex:add_rule('hr', 
             token('hr', 
			       lpeg.Cmt(lexer.starts_line(S(' \t')^0 * lpeg.C(S('*-_'))), 
				            function(input, index, c)
							  local line = input:match('[^\r\n]*', index):gsub('[ \t]', '')
							  if line:find('[^' .. c .. ']') or #line < 2 then 
							    return nil 
							  end
							  return (select(2, input:find('\r?\n', index)) or #input) + 1
							end)))
lex:add_style('hr', {back = lexer.colors.black, eolfilled = true})

-- Whitespace.
local ws = token(lexer.WHITESPACE, S(' \t')^1 + S('\v\r\n')^1)
lex:add_rule('whitespace', ws)

-- Span elements.
lex:add_rule('escape', token(lexer.DEFAULT, P('\\') * 1))

local ref_link_label = token('link_label', lexer.range('[', ']', true) * ':')
local ref_link_url = token('link_url', (lexer.any - lexer.space)^1)
local ref_link_title = token(lexer.STRING, lexer.range('"', true, false) +
  lexer.range("'", true, false) + lexer.range('(', ')', true))
lex:add_rule('link_label', ref_link_label * ws * ref_link_url *
  (ws * ref_link_title)^-1)
lex:add_style('link_label', lexer.styles.label)
lex:add_style('link_url', {fore = lexer.colors.blue, underlined = true})

local link_label = P('!')^-1 * lexer.range('[', ']', true)
local link_target = P('(') * (lexer.any - S(') \t'))^0 *
  (S(' \t')^1 * lexer.range('"', false, false))^-1 * ')'
local link_ref = S(' \t')^0 * lexer.range('[', ']', true)
local link_url = 'http' * P('s')^-1 * '://' * (lexer.any - lexer.space)^1
lex:add_rule('link', token('link', link_label * (link_target + link_ref) +
  link_url))
lex:add_style('link', {fore = lexer.colors.blue, underlined = true})

-- Added a style for local images (not URL based)
lex:add_rule('image',
             token('image', P('!')^1 *
                            lexer.delimited_range('[]') * 
                            lexer.delimited_range('()')))
lex:add_style('image', {fore = lexer.colors.blue, underlined = true})

local punct_space = lexer.punct + lexer.space

-- Handles flanking delimiters as described in
-- https://github.github.com/gfm/#emphasis-and-strong-emphasis in the cases
-- where simple delimited ranges are not sufficient.
local function flanked_range(s, not_inword)
  local fl_char = lexer.any - s - lexer.space
  local left_fl = lpeg.B(punct_space - s) * s * #fl_char +
    s * #(fl_char - lexer.punct)
  local right_fl = lpeg.B(lexer.punct) * s * #(punct_space - s) +
    lpeg.B(fl_char) * s
  return left_fl * (lexer.any - blank_line -
    (not_inword and s * #punct_space or s))^0 * right_fl
end

lex:add_rule('strong', token('strong', flanked_range('**') +
  (lpeg.B(punct_space) + #lexer.starts_line('_')) * flanked_range('__', true) *
  #(punct_space + -1)))
lex:add_style('strong', {fore = lexer.colors.yellow, bold = true})

lex:add_rule('em', token('em', flanked_range('*') +
  (lpeg.B(punct_space) + #lexer.starts_line('_')) * flanked_range('_', true) *
  #(punct_space + -1)))
lex:add_style('em', {fore = lexer.colors.yellow, italics = true})

lex:add_rule('code', token('code', P('```') * (lexer.any - '```')^0 * P('```')^-1 +
                                   lexer.delimited_range('`', true, true)))
lex:add_style('code', {fore = lexer.colors.teal, eolfilled = true})

-- Embedded HTML.
local html = lexer.load('html')
local start_rule = lexer.starts_line(P(' ')^-3) * #P('<') *
  html:get_rule('element') -- P(' ')^4 starts code_line
local end_rule = token(lexer.DEFAULT, blank_line) -- TODO: lexer.WHITESPACE errors
lex:embed(html, start_rule, end_rule)

-- Custom rules

-- Strings
lex:add_rule('quoted', token('quoted', lexer.delimited_range('"', true)))
lex:add_style('quoted', {fore = lexer.colors.yellow})

-- Strikeout
lex:add_rule('strikeout', token('strikeout', P('~~') * (lexer.any - '~~')^0 * P('~~')^-1))
lex:add_style('strikeout', {fore = lexer.colors.grey_black})

-- => conclusion
lex:add_rule('conclusion', token('conclusion', P('=>')))
lex:add_style('conclusion', {fore = lexer.colors.green, bold = true})
-- -> action
lex:add_rule('action', token('action', P('->')))
lex:add_style('action', {fore = lexer.colors.teal, bold = true})
-- /!\ warning
lex:add_rule('warning', token('warning', P('/!\\')))
lex:add_style('warning', {fore = lexer.colors.red, bold = true})
-- (!) idea (?) question
lex:add_rule('idea', token('idea', P('(!)') + P('(?)')))
lex:add_style('idea', {fore = lexer.colors.teal, bold = true})
-- [ ] to do
lex:add_rule('todo', token('todo', P('[ ]')))
lex:add_style('todo', {fore = lexer.colors.orange, bold = true})
-- [x] done
lex:add_rule('done', token('done', P('[x]')))
lex:add_style('done', {fore = lexer.colors.teal, bold = true})

-- TEST
-- lexer.colors.test = 0x164bcb
-- lex:add_rule('test', token('test', P('TEST')))
-- lex:add_style('test', {fore = lexer.colors.test, bold = true})

return lex
