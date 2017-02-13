function __fast_hg_prompt
  if test -e /usr/local/bin/scm-prompt
      bash -c 'source "/usr/local/bin/scm-prompt" && _dotfiles_scm_info "[%s]"'
      return
  end

  type -q vcprompt
  set -l has_vcprompt $status
  if test $has_vcprompt -eq 0
    vcprompt -t 150 -f "[%b]"
  end
end

function fish_prompt
  # Cache exit status
  set -l last_status $status

  # Just calculate these once, to save a few cycles when displaying the prompt
  if not set -q __fish_prompt_hostname
    set -g __fish_prompt_hostname (hostname|cut -d . -f 1)
  end
  if not set -q __fish_prompt_char
    switch (id -u)
      case 0
        set -g __fish_prompt_char \u276f\u276f
      case '*'
        set -g __fish_prompt_char »
    end
  end

  # Setup colors
  set -l normal (set_color normal)
  set -l cyan (set_color cyan)
  set -l blue (set_color blue)
  set -l green (set_color green)
  set -l yellow (set_color yellow)
  set -l bpurple (set_color -o purple)
  set -l bred (set_color -o red)
  set -l bcyan (set_color -o cyan)
  set -l bwhite (set_color -o white)

  # Configure __fish_git_prompt
  set -g __fish_git_prompt_show_informative_status true
  set -g __fish_git_prompt_showcolorhints true

  # Color prompt char red for non-zero exit status
  set -l pcolor $bpurple
  if [ $last_status -ne 0 ]
    set pcolor $bred
  end

  # Top
  echo
  echo -n $blue(prompt_pwd)$normal $green(__fast_hg_prompt)$normal

  echo

  # Bottom
  echo -n $normal(date "+$c2%H$c0:$c2%M$c0")$normal $yellow$__fish_prompt_hostname$normal $cyan$USER$normal $pcolor$__fish_prompt_char $normal
end
