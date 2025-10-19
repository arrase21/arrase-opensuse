function fish_prompt -d "Write out the prompt"
    # Mostrar entorno virtual activo (Python)
    set venv ""
    if set -q VIRTUAL_ENV
        set venv (basename "$VIRTUAL_ENV")
        set venv "($venv) "
    end

    # Mostrar usuario@host, directorio y venv
    printf '%s%s@%s %s%s%s%s > ' \
        (set_color yellow) $USER $hostname \
        (set_color green) (prompt_pwd) (set_color normal) " " $venv
end
if status is-interactive # Commands to run in interactive sessions can go here

    # No greeting
    set fish_greeting

    # Use starship
    starship init fish | source
    # if test -f ~/.local/state/quickshell/user/generated/terminal/sequences.txt
    #     cat ~/.local/state/quickshell/user/generated/terminal/sequences.txt
    # end

    # Aliases
    alias ls 'eza --icons'
    alias clear "printf '\033[2J\033[3J\033[1;1H'"
    alias q 'qs -c ii'

    # aliases
    alias y "yazi"
    alias v "nvim"
    alias la "ls -A"
    alias ll "ls -l"
    alias lla "ll -A"
    alias t "tmux"
    alias g git
    alias cw "cd /home/arrase/workspaces/"
    alias mys "sudo systemctl start mysqld"
    alias mysk "sudo systemctl stop mysqld"
    alias htp "sudo systemctl start httpd"
    alias htpk "sudo systemctl stop httpd"
    alias pv "python -m venv .env"
    alias pva "source .env/bin/activate.fish"
    alias pga "source pgadmin4/bin/activate.fish"
    fish_add_path $HOME/.cargo/bin
    fish_add_path $HOME/.local/bin
    fish_add_path /home/arrase/.spicetify
    # fish_add_path $HOME ~/.local/share/nvim/mason/bin
    set -U fish_user_paths $HOME/.local/bin $fish_user_paths
end

