local hilbish = require("hilbish")

hilbish.opts.tips = false
hilbish.opts.autocd = true
hilbish.opts.greeting = false
hilbish.opts.motd = false
hilbish.opts.fuzzy = true
hilbish.inputMode("vim")

local _, editor, _ = hilbish.run("echo $EDITOR", false)
hilbish.alias("vim", editor:gsub("%s+$", ""))
hilbish.alias("top", "btop")
hilbish.alias("ls", "ls --color=always")
