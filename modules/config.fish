function fish_user_key_bindings
	bind \& 'handle_input_bash_conditional \&'
  bind \| 'handle_input_bash_conditional \|'
end

function handle_input_bash_conditional --description 'Function used for binding to replace && and ||'
	# This function is expected to be called with a single argument of either & or |
  # The argument indicates which key was pressed to invoke this function
  if begin; commandline --search-mode; or commandline --paging-mode; end
    # search or paging mode; use normal behavior
    commandline -i $argv[1]
    return
  end
  # is our cursor positioned after a '&'/'|'?
  switch (commandline -c)[-1]
  case \*$argv[1]
    # experimentally, `commandline -t` only prints string-type tokens,
    # so it prints nothing for the background operator. We need -c as well
    # so if the cursor is after & in `&wat` it doesn't print "wat".
    if test -z (commandline -c -t)[-1]
      # Ideally we'd just emit a backspace and then insert the text
      # but injected readline functions run after any commandline modifications.
      # So instead we have to build the new commandline
      #
      # NB: We could really use some string manipulation operators and some basic math support.
      # The `math` function is actually a wrawpper around `bc` which is kind of terrible.
      # Instead we're going to use `expr`, which is a bit lighter-weight.

      # get the cursor position
      set -l count (commandline -C)
      # calculate count-1 and count+1 to give to `cut`
      set -l prefix (expr $count - 1)
      set -l suffix (expr $count + 1)
      # cut doesn't like 1-0 so we need to special-case that
      set -l cutlist 1-$prefix,$suffix-
      if test "$prefix" = 0
        set cutlist $suffix-
      end
      commandline (commandline | cut -c $cutlist)
      commandline -C $prefix
      if test $argv[1] = '&'
        commandline -i '; and '
      else
        commandline -i '; or '
      end
      return
    end
  end
  # no special behavior, insert the character
  commandline -i $argv[1]
end

[ -n "$GOPATH" ]; or set -x GOPATH $HOME/go

set fish_user_paths
for cur in ~/.bin ~/npm/bin ~/go/bin
  if test -d "$cur"
    set fish_user_paths $fish_user_paths $cur
  end
end
# old utilsauce garbage
for cur in ~/.configs/util/utils/*
  if test -d "$cur/bin"
    set fish_user_paths $fish_user_paths "$cur/bin"
  else
    set fish_user_paths $fish_user_paths "$cur"
  end
end

for nativeBuildInput in (echo $nativeBuildInputs | tr ' ' '\n')
  set fish_user_paths $nativeBuildInput/bin $fish_user_paths
end

set -x NIX_AUTO_RUN true
set -x TERM xterm-256color

alias g      'git'
alias gst    'git status'
alias gd     'git diff'
alias gl     'git pull'
alias gup    'git pull --rebase'
alias gp     'git push'
alias gc     'git commit -v'
alias gc!    'git commit -v --amend'
alias gca    'git commit -v -a'
alias gca!   'git commit -v -a --amend'
alias gco    'git checkout'
alias gcm    'git checkout master'
alias gr     'git remote'
alias grv    'git remote -v'
alias grmv   'git remote rename'
alias grrm   'git remote remove'
alias grset  'git remote set-url'
alias grup   'git remote update'
alias gb     'git branch'
alias gba    'git branch -a'
alias gcount 'git shortlog -sn'
alias gcl    'git config --list'
alias gcp    'git cherry-pick'
alias glg    'git log --stat --max-count=5'
alias glgg   'git log --graph --max-count=5'
alias glgga  'git log --graph --decorate --all'
alias glo    'git log --oneline'
alias gss    'git status -s'
alias ga     'git add'
alias gm     'git merge'
alias grh    'git reset HEAD'
alias grhh   'git reset HEAD --hard'
alias gwc    'git whatchanged -p --abbrev-commit --pretty=medium'
alias gf     'git ls-files | grep'
alias gpoat  'git push origin --all; and git push origin --tags'
alias grt    'cd (git rev-parse --show-toplevel; or echo ".")'

alias git-svn-dcommit-push 'git svn dcommit; and git push github master:svntrunk'
alias gsr 'git svn rebase'
alias gsd 'git svn dcommit'

function certgen
  go run (go env GOROOT)/src/crypto/tls/generate_cert.go $argv
end

alias zfs 'sudo zfs'
alias zpool 'sudo zpool'
alias ls 'exa'
alias hx /home/itzmjauz/.cargo/bin/hx # possibly non-existent path, but this binary is so painful to build; writing a proper builder is too much work.
set -x HELIX_RUNTIME ~/src/github.com/helix-editor/helix/runtime/ # similar to above
#alias vim 'nvim'
