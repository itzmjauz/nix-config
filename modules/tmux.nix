{ config, pkgs, ... }:
{
  environment = {
    systemPackages = [ pkgs.tmux ];

    etc."tmux.conf".text = ''
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

      # enable mouse control
      # since tmux 2.1+ this is one command
      set -g mouse on

      # don't rename automatically
      set-option -g allow-rename off

      # loud or quiet
      #set -g visual-activity off
      #set -g visual-bell off
      #set -g visual-silence off
      #setw -g monitor-acitvity on
      #set -g bell-action none

      # modes
      setw -g clock-mode-colour colour5
      setw -g mode-style 'fg=colour1 bg=colour18 bold'

      # panes
      set -g pane-border-style 'fg=colour19 bg=colour0'
      set -g pane-active-border-style 'bg=colour0 fg=colour9'

      # statusbar
      set -g status-position bottom
      set -g status-justify left
      set -g status-style 'bg=colour18 fg=colour137 dim'
      set -g status-right '#[fg=colour233, bg=colour19] %d/%m #[fg=colour233, bg=colour8] %H:%M:%S '
      set -g window-status-current-style 'fg=colour1 bg=colour19 bold'
      set -g window-status-current-format '#I#[fg=colour249]:#[fg=colour255]#W#[fg=colour249]#F '

      set -g window-status-style 'fg=colour9 bg=colour18'
      set -g window-status-format '#I#[fg=colour237]:#[fg=colour250]#W#[fg=colour244]#F '

      set -g window-status-bell-style 'fg=colour255 bg=colour1 bold'

      # messages
      set -g message-style 'fg=colour232 bg=colour16  bold'
        
    '';
  };
}
