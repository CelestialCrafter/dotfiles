from libqtile.config import Group

groups = [Group(n, layout="max" if n == "s" else None) for n in "1234s"]
