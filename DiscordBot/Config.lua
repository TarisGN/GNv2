DiscordWebhookSystemInfos = 'https://discordapp.com/api/webhooks/572010716282880021/WThwD33tSCinGslnsFGchf68PqaQIzwb3f2c6roMIv-E5H1ZeaEtnmepr3YvMf9WxQlM'
DiscordWebhookKillinglogs = 'https://discordapp.com/api/webhooks/578149654022062100/BMcLJ7zO6USaSp5-TqTMddQ7UC0Lxg5_2RkYTNJLQlLuRZU0GXkx8Qq9e9IcPmTgNHhU'
DiscordWebhookChat = 'https://discordapp.com/api/webhooks/572010716282880021/WThwD33tSCinGslnsFGchf68PqaQIzwb3f2c6roMIv-E5H1ZeaEtnmepr3YvMf9WxQlM'

SystemAvatar = 'https://wiki.fivem.net/w/images/d/db/FiveM-Wiki.png'

UserAvatar = 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTVWa2P8w8gdr47ZHhv34OJdkzUESytvE4kr9IESI9UHd1Rp3AFRQ'

SystemName = 'SYSTEM'


--[[ Special Commands formatting
		 *YOUR_TEXT*			--> Make Text Italics in Discord
		**YOUR_TEXT**			--> Make Text Bold in Discord
	   ***YOUR_TEXT***			--> Make Text Italics & Bold in Discord
		__YOUR_TEXT__			--> Underline Text in Discord
	   __*YOUR_TEXT*__			--> Underline Text and make it Italics in Discord
	  __**YOUR_TEXT**__			--> Underline Text and make it Bold in Discord
	 __***YOUR_TEXT***__		--> Underline Text and make it Italics & Bold in Discord
		~~YOUR_TEXT~~			--> Strikethrough Text in Discord
]]
-- Use 'USERNAME_NEEDED_HERE' without the quotes if you need a Users Name in a special command
-- Use 'USERID_NEEDED_HERE' without the quotes if you need a Users ID in a special command


-- These special commands will be printed differently in discord, depending on what you set it to
SpecialCommands = {

				  }

						
-- These blacklisted commands will not be printed in discord
BlacklistedCommands = {
					   '/AnyCommand',
					   '/AnyCommand2',
					  }

-- These Commands will use their own webhook
OwnWebhookCommands = {
					  {'/car', 'https://discordapp.com/api/webhooks/578149654022062100/BMcLJ7zO6USaSp5-TqTMddQ7UC0Lxg5_2RkYTNJLQlLuRZU0GXkx8Qq9e9IcPmTgNHhU'},
					  {'/giveitem', 'https://discordapp.com/api/webhooks/578149654022062100/BMcLJ7zO6USaSp5-TqTMddQ7UC0Lxg5_2RkYTNJLQlLuRZU0GXkx8Qq9e9IcPmTgNHhU'},
					  {'/giveweapon', 'https://discordapp.com/api/webhooks/578149654022062100/BMcLJ7zO6USaSp5-TqTMddQ7UC0Lxg5_2RkYTNJLQlLuRZU0GXkx8Qq9e9IcPmTgNHhU'},
					  {'/911', 'https://discordapp.com/api/webhooks/578149654022062100/BMcLJ7zO6USaSp5-TqTMddQ7UC0Lxg5_2RkYTNJLQlLuRZU0GXkx8Qq9e9IcPmTgNHhU'},
					  {'/ad', 'https://discordapp.com/api/webhooks/578149654022062100/BMcLJ7zO6USaSp5-TqTMddQ7UC0Lxg5_2RkYTNJLQlLuRZU0GXkx8Qq9e9IcPmTgNHhU'},
					  {'/anontweet', 'https://discordapp.com/api/webhooks/578149654022062100/BMcLJ7zO6USaSp5-TqTMddQ7UC0Lxg5_2RkYTNJLQlLuRZU0GXkx8Qq9e9IcPmTgNHhU'},

					  
					 }

-- These Commands will be sent as TTS messages
TTSCommands = {
			   '/Whatever',
			   '/Whatever2',
			  }

