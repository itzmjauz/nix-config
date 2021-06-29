{ config, pkgs, ... }:
{
  environment = {
    systemPackages = [ pkgs.tmux ];

    etc."tmux.conf".text = ''
      # delays in escaping insert mode in kakoune
      set -sg escape-time 0

      # make nvim work within tmux
      set -g default-terminal "tmux-256color"
      set-option -ga terminal-overrides ",tmux-256color:Tc"

      # remap prefix from c-b to c-a 
      unbind C-b
      set-option -g prefix C-a
      bind C-a send-prefix

      # some nice extra split commands
      bind | split window -h
      bind - split window -v
      # optional unbind
      # unbind '"'
      # unbind %

      # easier pane switching (prefix-n , prefix-p)
      bind -n M-Left select-pane -L
      bind -n M-Right select-pane -R
      bind -n M-Up select-pane -U
      bind -n M-Down select-pane -D

      # easier window switching
      bind -n M-S-Left previous-window
      bind -n M-S-Right next-window

      # enable mouse control
      # since tmux 2.1+ this is one command
      set -g mouse on

      # don't rename automatically
      set-option -g allow-rename off


      #### COLOUR (Solarized 256)

      # default statusbar colors
      set-option -g status-style fg=colour136,bg=colour235 #yellow and base02

      # default window title colors
      set-window-option -g window-status-style fg=colour244,bg=default #base0 and default
      #set-window-option -g window-status-style dim

      # active window title colors
      set-window-option -g window-status-current-style fg=colour166,bg=default #orange and default
      #set-window-option -g window-status-current-style bright

      # pane border
      set-option -g pane-border-style fg=colour235 #base02
      set-option -g pane-active-border-style fg=colour240 #base01

      # message text
      set-option -g message-style fg=colour166,bg=colour235 #orange and base02

      # pane number display
      set-option -g display-panes-active-colour colour33 #blue
      set-option -g display-panes-colour colour166 #orange

      # clock
      set-window-option -g clock-mode-colour colour64 #green

      # bell
      set-window-option -g window-status-bell-style fg=colour235,bg=colour160 #base02, red
      '';
  };
}
