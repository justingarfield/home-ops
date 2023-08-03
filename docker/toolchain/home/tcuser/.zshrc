HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.history
if [[ -d "~/.out-folder" ]]; then
  HISTFILE=~/.out-folder/.history
fi

# Use modern completion system
autoload -Uz compinit
compinit

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source ~/src/romkatv/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Show the MOTD
[ ! -z "$TERM" -a -r /etc/motd ] && cat /etc/motd

# Configure auto-completion
[[ $commands[cilium] ]] && source <(cilium completion zsh)
[[ $commands[clusterctl] ]] && source <(clusterctl completion zsh)
[[ $commands[crictl] ]] && source <(crictl completion zsh)
[[ $commands[flux] ]] && source <(flux completion zsh)
[[ $commands[gh] ]] && source <(gh completion --shell zsh)
[[ $commands[helm] ]] && source <(helm completion zsh)
[[ $commands[hubble] ]] && source <(hubble completion zsh)
[[ $commands[kubeadm] ]] && source <(kubeadm completion zsh)
[[ $commands[kubectl] ]] && source <(kubectl completion zsh)
[[ $commands[talosctl] ]] && source <(talosctl completion zsh)
[[ $commands[tetra] ]] && source <(tetra completion zsh)
[[ $commands[yq] ]] && source <(yq shell-completion zsh)

# Terraform is special
autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/local/bin/terraform terraform

source /home/tcuser/src/zsh-users/zsh-autosuggestions/zsh-autosuggestions.zsh

export PATH=~/.local/bin:$PATH
