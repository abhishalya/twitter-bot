# twitter-bot

Twitter meme bot written in Julia. This will post one random meme to your
twitter account.

To run the bot, first set the environment variables as follows:

```
BOT_C_KEY = <YOUR_TWITTER_CONSUMER_KEY>
BOT_C_SEC = <YOUR_TWITTER_CONSUMER_SECRET>
BOT_A_TOK = <YOUR_TWITTER_ACCESS_TOKEN>
BOT_A_SEC = <YOUR_TWITTER_ACCESS_TOKEN_SECRET>
```

Once this is done, simply run:

```
julia src/bot.jl
```

This uses https://github.com/R3l3ntl3ss/Meme_Api to get the memes.
