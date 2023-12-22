# ta-config

## Summary

Short said, my personal configuration for [Textadept](https://foicica.com/textadept/)
I use this editor as a lightweight all-purpose editor, especially for text and markdown editing, to synthetize technical documentations and analysis.

Following configurations are available:
- solarized dark theme from [rgieseke/textadept-themes: Themes for the Textadept editor](https://github.com/rgieseke/textadept-themes)
- a more natural, to me at least, implementation of MRU taken from [gabdub/ta-tweaks: This is a collection of my Textadept tweaks](https://github.com/gabdub/ta-tweaks)
- a favourite files manager
- an adapted markdown lexer
- a dynamic highlighting of the current word or selection
- a color hint for color codes
- some helpers for the search operations (initialization, shortcuts)
- some helpers for french language (for text and markdown edition)
- some helpers for editing (for markdown language)
- integration of the distraction free mode

## Favourite files manager

- List the favourite files in: `~\.textadept\textadept.favs`
- One file path per line
- Use menu "Tools\My Tools\Favourites...", to display list of files
- Choose one file, hit return and it opens

## Adapted markdown lexer

Some enhancements / modifications to original markdown lexer of TextAdept
- all styles with same font size, even titles
- adapted colour styles to my tastes
- added a quoted string style (does not exist in markdown, but I like it)
- added strikeout style (markdown)
- added highlighting for some markers I use often:
  /!\ warning
  (!) idea
  (?) question
  => conclusion
  -> action
  [ ] todo
  [x] done

## Automatical dynamic highlighting

Automatically highlight the occurences of the current word or the select text (might be anything: some letters, several words or even lines)

## Color hint for color codes

Works currently for the *BGR color codes* like `0xBBGGRR`
When the cursor is in such word like a color code, it automatically underlines the word with the color corresponding to the color code.
Very useful when you try to define the color set of a theme.

![Color hint sample](https://github.com/alain-riedinger/ta-config/blob/master/modules/color_hint/TextAdept-Color%20hint.png)

## French language helpers

French keyboard layout is miserable when it comes to type code, so I adapted it a little bit:
- **²** for a backquote
- **Shift+²** enters 3 back quotes for a code block
- **Ctrl+²** quotes the selected text or the current word with a back quote
- **'** the single quote is not automatically doubled, because in french it is often used in natural language

## Search helpers

Some helpers added to ease the search operations:
- **Ctrl+F3** searches for the next current selection or current word
- **Shift+Ctrl+F3** searches for the previous current selection or current word
- **Ctrl+F** displays the search strip initialized with the current selection or the current word

## Text edition helpers

Some helpers added to ease text edition operations:
- **Ctrl+"** quotes the selected text, if any, or the current word
- __Ctrl+*__ quotes with a star the selected text, if any, or the current word
- **Ctrl+_** quotes with an underscore the selected text, if any, or the current word

## Distraction free mode

Distraction free mode is composed of:
- a full full screen extension
- menu bar is hidden
This functionality works as a toggle from and to this mode.

## Copy file path

Accessible from the tab menu:
- copies the full path of the file opened in the buffer

## Text statistics

Accessible from context menu in the buffer:
- displays the statistics for either the selected text (if one) or the total text in the buffer
- displayed statistics are number of characters, digits, spaces, signs and others

## Tablify (markdown helper)

The goal of this feature is to changed a raw table syntax in markdown to a nice formed and human readable table.  
Accessible from the context menu in the buffer:
- converts the select text to a nicely layedout mardown table
```
head1 | head2 | head 3
--- | --- | ---
vallll11 | val12 | vvval13
val21 | vaaaal22 | val23
```
becomes:
```
|head1    | head2    | head 3 |
|---      | ---      | ---    |
|vallll11 | val12    | vvval13|
|val21    | vaaaal22 | val23  |
```
