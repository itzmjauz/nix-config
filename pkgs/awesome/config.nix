{ lib, runCommand }:
runCommand "awesomesauce" {
  src = builtins.filterSource (path: type: type != "directory" || !(lib.hasPrefix "." (baseNameOf path))) ./config;
  meta.priority = 4; # take precedence over the builtin /etc/xdg/awesome/rc.lua
  preferLocalBuild = true;
} ''
  mkdir -p $out/etc/xdg
  cp -r $src $out/etc/xdg/awesome
  for f in $(find $out -type f -name \*.lua); do
    substituteAllInPlace $f
  done
''
