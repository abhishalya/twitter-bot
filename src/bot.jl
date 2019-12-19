using Base64, HTTP, JSON

include("auth.jl")

MEME_API = "https://meme-api.herokuapp.com/"
POST_TWEET_URL = "https://api.twitter.com/1.1/statuses/update.json"
TWITTER_UPLOAD_URL = "https://upload.twitter.com/1.1/media/upload.json"

# This is a deprecated method for media upload
function upload_meme_file(name)
    img_data = ""
    try
        open(name) do file
            img_data = read(file)
        end
    catch
        println("File does not exist.")
        exit(1)
    end
    options = Dict("media" => base64encode(img_data),
                   "media_category" => "tweet_image")
    req = post_oauth(TWITTER_UPLOAD_URL, options)
    print("UPLOAD (deprecated): ", req.status)
    json = JSON.parse(String(req.body))
    return json["media_id"]
end

function upload_by_chunk(name)
    img_data = ""
    img_size = 0
    try
        open(name) do file
            img_data = read(file)
            img_size = stat(file).size
        end
    catch
        println("File does not exist.")
        exit(1)
    end
    init_opt = Dict("command" => "INIT",
                    "total_bytes" => img_size,
                    "media_type" => "image/jpeg",
                    "media_category" => "tweet_image")
    r_init = post_oauth(TWITTER_UPLOAD_URL, init_opt)
    println("INIT: ", r_init.status)
    json = JSON.parse(String(r_init.body))
    return upload_append(img_data, json["media_id"])
end

function upload_append(img_data, media_id)
    append_opt = Dict("command" => "APPEND",
                      "media_id" => media_id,
                      "media" => base64encode(img_data),
                      "segment_index" => 0)
    r_append = post_oauth(TWITTER_UPLOAD_URL, append_opt)
    println("APPEND: ", r_append.status)
    return upload_finalize(media_id)
end

function upload_finalize(media_id)
    final_opt = Dict("command" => "FINALIZE",
                     "media_id" => media_id)
    r_final = post_oauth(TWITTER_UPLOAD_URL, final_opt)
    println("FINALIZE: ", r_final.status)
    return media_id
end

function get_meme()
    try
        channel_list = ["ProgrammerHumor", "dankmemes"]
        selection = rand(1 : 2, 1)[1]
        url = MEME_API * "gimme/" * channel_list[selection] * "/1"
        req = HTTP.request("GET", url)
        println("MEME: ", req.status)
        json = JSON.parse(String(req.body))
        img_url = json["memes"][1]["url"]
        extension = split(img_url, ".")[end]
        img_name = "image.$extension"
        download(img_url, img_name)
        return json, img_name
    catch
        println("Something went wrong. Sorry.")
        exit(1)
    end
end

function post_tweet()
    meme, name = get_meme()
    post_link = meme["memes"][1]["postLink"]
    title = meme["memes"][1]["title"]
    media_id = upload_by_chunk(name)
    options = Dict("status" => "$title\n\nSource: $post_link",
                   "media_ids" => media_id)
    r_tweet = post_oauth(POST_TWEET_URL, options)
    println("TWEET: ", r_tweet.status)
end

post_tweet()
