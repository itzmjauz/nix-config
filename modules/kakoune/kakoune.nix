{ config, pkgs, ... }:
let 
  config = pkgs.writeTextFile (rec {
    name = "kakrc.kak";
    destination = "/share/kak/autoload/${name}";
    text = builtins.readFile ./kakrc.kak;
  });
in
{
  environment.systemPackages = with pkgs; [
    (kakoune.override {
      configure = {
        plugins = with pkgs.kakounePlugins; [ config parinfer-rust kak-lsp kak-powerline kak-auto-pairs ];
      };
    })
  ];
}
  
