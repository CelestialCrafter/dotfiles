local hilbish = require("hilbish")

hilbish.opts.tips = false
hilbish.opts.autocd = true
hilbish.opts.greeting = false
hilbish.opts.motd = false
hilbish.opts.fuzzy = true
hilbish.inputMode("vim")

hilbish.alias("vim", "$EDITOR")
hilbish.alias("top", "btop")
hilbish.alias("ls", "ls --color=always")
