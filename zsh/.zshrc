# macOS original terminal
export CLICOLOR=1
export LSCOLORS=ExGxFxdaCxDaDahbadeche
autoload -U colors && colors
PROMPT="%{$fg_bold[red]%}%n%{$reset_color%}@%{$fg_bold[red]%}%m %{$fg_bold[blue]%}%1~ %{$reset_color%}%# "
