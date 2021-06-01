# daboross's kakrc
#
# ###
#
# Copyright (c) 2019 David Ross
#
# This software is provided 'as-is', without any express or implied
# warranty. In no event will the authors be held liable for any damages
# arising from the use of this software.
#
# Permission is granted to anyone to use this software for any purpose,
# including commercial applications, and to alter it and redistribute it
# freely.
#
# ###
#
# Plugins Required:
# - https://github.com/alexherbo2/auto-pairs.kak
# - https://github.com/ul/kak-lsp
#
# I recommend installing https://github.com/rust-analyzer/rust-analyzer/ and configuring
# kak-lsp to use it for Rust.
#
# ###


# ###
# General Preferences
# ###

# gruvbox!
colorscheme solarized-light

# save a bit of window space by removing clippy from popups
set global ui_options ncurses_assistant=off

# add line numbers
add-highlighter global/ number-lines

# if not configured per file type, just wrap to 100 characters
add-highlighter global/ wrap -width 101 -indent -word
set global autowrap_column 100
set global autowrap_fmtcmd 'fmt -w %c'

# if not configured per file type, set tabs as 4 spaces
set global tabstop 4

# insert 4 spaces on tab key
hook global InsertChar \t %{ exec -draft -itersel h@ } -group kakrc-replace-tabs-with-spaces

# # use tab for tab completion (https://github.com/mawww/kakoune/issues/1327)
# hook global InsertCompletionShow .* %{
#     map window insert <tab> <c-n>
#     map window insert <s-tab> <c-p>
# }
#
# hook global InsertCompletionHide .* %{
#     unmap window insert <tab> <c-n>
#     unmap window insert <s-tab> <c-p>
# }

# ###
# Document Cleanup Utilities
# ###

define-command -params 0 -docstring %{
    clear all whitespace before newlines in the current file
} whitespace-clear %{
    try %{
        # this is an attempt at clearing all whitespace except that on the current line
#       execute-keys -no-hooks -draft <a-x> '"' a y <a-h> <a-h> Z '%' s\h+$ <ret> d z <a-x> '"' a R
       execute-keys -draft '%s\h+$<ret>d'
    }
}

define-command -params 0 -docstring %{
    replaces all tabs with spaces in the current file
} tabs-to-spaces %{
    try %{
        execute-keys -draft '%s\t<ret>c<tab>'
    }
}

define-command -params 0 -docstring "removes whitespace before newlines and tabs->spaces" cleanup %{
    eval %sh{
        if [ "$kak_opt_filetype" != 'python' ] && [ "$kak_opt_filetype" != 'javascript' ]; then
            echo "whitespace-clear"
        fi
    }
    eval %sh{
        if [ "$kak_opt_filetype" != 'makefile' ]; then
            echo "tabs-to-spaces"
        fi
    }
}

# ###
# Utility Commands
# ###

define-command -params 0 -docstring "copies the current selection into the OS copy buffer" copy %{
    execute-keys -draft <a-|> xclip <space> -sel <space> clip <ret>
}

define-command -params 1 -file-completion -docstring "executes mkdir -p" mkdir %{
    nop %sh{ mkdir -p "$1" }
}

define-command -params 1 -file-completion -docstring "sends file to trash" rm %{
    nop %sh{ trash "$1" }
}

define-command -params 0 -docstring "removes spell checker highlighting" unspell %{
    try %{
        remove-highlighter 'window/ranges_spell_regions'
    }
}

# ###
# Utility Mappings
# ###

map -docstring 'format' global user f ': format<ret>'
map -docstring 'wrap' global user j '<a-x>|fmt -w $(($kak_opt_autowrap_column + 1)) -g $kak_opt_autowrap_column<ret>'
map -docstring 'down' global user d '<c-d>gc'
map -docstring 'up' global user u '<c-u>gc'
map -docstring 'up' global user e ': lsp-find-error<ret>'
map -docstring 'lsp' global user l ': enter-user-mode lsp<ret>'

# ###
# Dealing With Brackets
# ###

# highlight matching brackets when moving cursor in normal mode
hook global WinCreate .* %{
    add-highlighter window/ show-matching
}

# highlight the matching bracket immediately after inserting a new bracket

# on insertion, highlights the matching character to the character just typed
# see: https://github.com/mawww/kakoune/issues/1192#issuecomment-301414674
# (this is a version changed to remove highlight after any action)
declare-option -hidden range-specs show_matching_range

hook global -group kakrc-matching-ranges InsertChar '[[\](){}<>]' %{
    eval -draft %{
        try %{
            exec '<esc>;hm<a-k>..<ret>;'
            set window show_matching_range %val{timestamp} "%val{selection_desc}|MatchingChar"
        } catch %{
            set window show_matching_range 0
        }
        hook window -group kakrc-matching-ranges-temp-hooks InsertChar '[^[\](){}<>]' %{
            set window show_matching_range 0
            remove-hooks window kakrc-matching-ranges-temp-hooks
        }
        hook window -group kmrih-temp557 ModeChange .* %{
            set window show_matching_range 0
            remove-hooks window kakrc-matching-ranges-temp-hooks
        }
        hook window -group kakrc-matching-ranges-temp-hooks InsertMove .* %{
            set window show_matching_range 0
            remove-hooks window kakrc-matching-ranges-temp-hooks
        }
    }
}

add-highlighter global/ ranges show_matching_range

# Enable 'auto-pairs' plugin for all filetypes
hook global WinCreate .* %{
    auto-pairs-enable
}

# ###
# Filetype Specific Options
# ###

hook global WinSetOption filetype=rust %{
    # format rust code with 'rustfmt'
    set buffer formatcmd 'rustfmt'

    # rust code uses tabs as 4 spaces
    set buffer tabstop 4
    set buffer indentwidth 4

    # rust code uses 120-width lines
    add-highlighter buffer/ wrap -word -width 120
    set buffer autowrap_column 120

    # the default auto-pairs pair list includes the single quote ', which is not usually paired in
    # Rust
    set buffer auto_pairs ( ) { } [ ] \" \" ` `

    # autocompletion via 'rls' is enabled at the bottom of the file.
    # disabled for now
    # lsp-auto-hover-enable

    # show function signature when writing function calls
    lsp-auto-signature-help-enable
}

hook global WinSetOption filetype=c %{
    # the C code I work on usually has tabs as 2 spaces
    set buffer tabstop 2
    set buffer indentwidth 2

    # show function signature when writing function calls
    lsp-auto-signature-help-enable
}

# Racket does not have a dedicated filetype
hook global BufCreate .*[.](racket|rkt) %{
    # treat racket code as common lisp code, it's close enough
    set buffer filetype lisp
}

hook global WinSetOption filetype=lisp %{
    # use 2-space tabs in lisp files
    set buffer tabstop 2
    set buffer indentwidth 2
}

hook global WinSetOption filetype=git-commit %{
    # wrap to 70 lines
    add-highlighter buffer/ wrap -word -width 72
    set window autowrap_column 71
    # auto-wrap lines
    autowrap-enable
}

hook global BufCreate .*[.](txt|text) %{
    # don't limit text file lines to 100 characters
    add-highlighter buffer/ wrap -word
}

# ###
# Extensions
# ###

# enable kak-lsp
eval %sh{ kak-lsp --kakoune -s $kak_session }

# output debug logs for kak-lsp
nop %sh{
    (kak-lsp -s $kak_session -vvv ) > /tmp/lsp_"$(date +%F-%T-%N)"_kak-lsp_log 2>&1 < /dev/null &
}

# enable kak-lsp globally
lsp-enable

# ###
# Experimental Extensions
# ###

# rofi...?
# TODO: encorporate https://discuss.kakoune.com/t/recently-edited-files/587
define-command rofi-buffers -docstring 'Select an open buffer using Rofi' %{
    %sh{
        BUFFER=$(printf %s\\n "${kak_buflist}" | tr : '\n' | rofi -dmenu)
        if [ -n "$BUFFER" ]; then
            echo "eval -client '$kak_client' 'buffer ${BUFFER}'" | kak -p ${kak_session}
        fi
    }
}
