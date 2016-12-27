{ pkgs, ... }:
let
  file = pkgs.fetchurl {
    url = https://raw.githubusercontent.com/seebi/dircolors-solarized/e6fa8d4c0f64d9758e7ff32fe8d10f9800396d3c/dircolors.256dark;
    sha256 = "1353gjvyv20mdd8fcmg978f5a3php330y6g582f23hqwrsnvrzwl";
  };
  cmd = "${pkgs.coreutils}/bin/dircolors ${file}";
in
{
  programs.bash.interactiveShellInit = ''
    eval `${cmd}`
  '';

  programs.zsh.interactiveShellInit = ''
    eval `${cmd}`
  '';

  programs.fish.interactiveShellInit = ''
    eval (${cmd} -c)
  '';
}
