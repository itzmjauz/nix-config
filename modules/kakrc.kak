# theme
colorscheme gruvbox
# colorscheme solarized-light

# add line numbers
add-highlighter global/ number-lines

# enable auto-pair
hook global WinCreate .* %{
    auto-pairs-enable
}

# global tabstop
set global tabstop 4

# replace tabs with spaces
define-command -params 0 -docstring %{
 	replaces all tabs with spaces in the current file
} tabs-to-spaces %{
  	try %{
    	execute-keys -draft '%s\t<ret>c<tab>'
  	}
}

# tabs to spaces
hook global InsertChar \t %{
    exec -draft h@
}

# enable lsp for rust
eval %sh{kak-lsp --kakoune -s $kak_session}  # Not needed if you load it with plug.kak.

# rust config
hook global WinSetOption filetype=(rust) %{ # enable per filetype
    # set fmt command
	set buffer formatcmd 'rustfmt'
	# defaults for rust
	set buffer tabstop 4
	set buffer indentwidth 4
	# lsp 
	lsp-enable-window
    lsp-auto-hover-enable
    lsp-auto-signature-help-enable
#    lsp-inlay-diagnostics-enable window

	# rust inlay hints
    hook window -group rust-inlay-hints BufReload .* rust-analyzer-inlay-hints
    hook window -group rust-inlay-hints NormalIdle .* rust-analyzer-inlay-hints
    hook window -group rust-inlay-hints InsertIdle .* rust-analyzer-inlay-hints
    hook -once -always window WinSetOption filetype=.* %{
    	remove-hooks window rust-inlay-hints
    }

	# format buffer sync
    hook window BufWritePre .* lsp-formatting-sync
}

# user mode
map global user l %{: enter-user-mode lsp<ret>} -docstring "LSP mode"

