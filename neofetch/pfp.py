#!/usr/bin/env python

import discord, os, sys

USER_ID = 767450906164985877

# i hate discord libraries. stop messing with my event loop, logging, and error handling please <3

try:
	intents = discord.Intents.default()
	client = discord.Client(intents=intents)

	@client.event
	async def on_ready():
		try:
			user = await client.fetch_user(USER_ID)
			print(user.display_avatar.replace(size = 2048, format = 'png').url)
			os._exit(0)
		except Exception as e:
			print(e, file = sys.stderr)
			os._exit(1)

	client.run(open(f'{os.path.dirname(os.path.realpath(__file__))}/token.txt').read(), log_handler = None)
except Exception as e:
	print(e, file = sys.stderr)
	os._exit(1)