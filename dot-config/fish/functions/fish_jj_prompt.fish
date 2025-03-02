function fish_jj_prompt
    # If jj isn't installed, there's nothing we can do
    # Return 1 so the calling prompt can deal with it
    if not command -sq jj
        return 1
    end

	set -l info "$(jj log 2>/dev/null --no-graph --ignore-working-copy --color=always --revisions @ --template '
		separate(commit_summary_separator,
			format_short_change_id_with_hidden_and_divergent_info(self),
			separate(" ",
				if(self.conflict(), label("conflict", "(conflict)")),
				if(self.empty(), label("empty", "(empty)")),
			)
		)
	')"
    or return 1
    if test -n "$info"
        printf ' %s' $info
    end
end
