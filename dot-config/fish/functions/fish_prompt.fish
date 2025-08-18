function fish_prompt
    if test $status -eq 0
        set -f status_color (set_color $fish_color_user)
    else
        set -f status_color (set_color $fish_color_status)
    end

    printf "%s%s %s%s%s%s " \
        $status_color $USER \
        (set_color $fish_color_cwd) (basename (string replace $HOME "~" $PWD)) \
        (fish_jj_prompt) \
        (set_color normal)
end
