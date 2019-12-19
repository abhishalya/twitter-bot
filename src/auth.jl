using OAuth

BOT_C_KEY = ENV["BOT_C_KEY"]
BOT_C_SEC = ENV["BOT_C_SEC"]
BOT_A_TOK = ENV["BOT_A_TOK"]
BOT_A_SEC = ENV["BOT_A_SEC"]

get_oauth(endpoint::String,
          options::Dict) = oauth_request_resource(endpoint,
                                                  "GET",
                                                  options,
                                                  BOT_C_KEY,
                                                  BOT_C_SEC,
                                                  BOT_A_TOK,
                                                  BOT_A_SEC)

post_oauth(endpoint::String,
           options::Dict) = oauth_request_resource(endpoint,
                                                   "POST",
                                                   options,
                                                   BOT_C_KEY,
                                                   BOT_C_SEC,
                                                   BOT_A_TOK,
                                                   BOT_A_SEC)
