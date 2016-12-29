{ lib, writeTextFile, ... }: with lib;
let
  toTerminator = value: concatStrings (mapAttrsToList (toTerminator' id) value);
  toTerminator' = wrap: key: value: if isAttrs value
    then (let
        wrap' = x: "[${wrap x}]";
        wrappedKey = "${wrap' key}\n";
        toTerminator = toTerminator' wrap';
      in concatStrings ([ wrappedKey ] ++ (mapAttrsToList toTerminator value)))
    else "${key} = ${toString value}\n";
  toString = x: if x == null
    then "None"
    else if x == true  then "True"
    else if x == false then "False"
    else if (isString x) && (hasPrefix "#" x) then ''"${x}"''
    else x;
  toConfig = attrs: writeTextFile {
    name = "terminator-config";
    text = toTerminator attrs;
    destination = "/etc/xdg/terminator/config";
  };
in toConfig {
  global_config = {
    focus = "mouse";
    tab_position = "right";
  };
  keybindings = {
    broadcast_all = null;
    broadcast_group = null;
    broadcast_off = null;
    go_left = "<Shift><Ctrl>H";
    go_down = "<Shift><Ctrl>J";
    go_up = "<Shift><Ctrl>K";
    go_right = "<Shift><Ctrl>L";
    group_all = null;
    edit_window_title = null;
    new_window = "<Shift><Super>Return";
    next_tab = "<Shift>Right";
    paste = "<Shift>Insert";
    prev_tab = "<Shift>Left";
  };
  layouts.default = {
    child1 = {
      parent = "window0";
      profile = "default";
      type = "Terminal";
    };
    window0 = {
      parent = ''""'';
      type = "Window";
    };
  };
  plugins = {};
  profiles = let
    common = {
      background_image = null;
      font = "Source Code Pro Semibold 11";
      scrollback_infinite = true;
      scrollbar_position = "hidden";
      show_titlebar = false;
      use_system_font = false;
    };
  in {
    default = common // {
      background_color = "#002b36";
      cursor_color = "#eee8d5";
      foreground_color = "#eee8d5";
      palette = "#073642:#dc322f:#859900:#b58900:#268bd2:#d33682:#2aa198:#eee8d5:#006580:#cb4b16:#586e75:#657b83:#839496:#6c71c4:#93a1a1:#fdf6e3";
    };
    light = common // {
      background_color = "#eee8d5";
      cursor_color = "#002b36";
      foreground_color = "#002b36";
      palette = "#073642:#dc322f:#859900:#b58900:#268bd2:#d33682:#2aa198:#eee8d5:#002b36:#cb4b16:#586e75:#657b83:#839496:#6c71c4:#93a1a1:#fdf6e3";
    };
  };
}
