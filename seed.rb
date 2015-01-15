require 'redis'

redis = Redis.new
redis.flushdb
redis.set("bar_id",0)

id = redis.incr("bar_id")
redis.hmset(
  "bar:#{id}",
  "name", "Penrose",
  "location", "2nd ave btw 82nd and 83rd",
  "picture", "http://www.penrosebar.com/IMG/home05.jpg",
  "text", "An upscale bar with modestly priced drinks, a solid atmosphere, and a sophisticated crowd",
  "author", "chaddpaul",
  "region", "UES"
  )
redis.lpush("bar_ids",id)

id = redis.incr("bar_id")
redis.hmset(
  "bar:#{id}",
  "name", "B-Bar",
  "location", "4th and Bowery",
  "picture", "https://cbsnewyork.files.wordpress.com/2011/10/b-bar.jpg",
  "text", "A hopping location downtown with a younger crowd. It has three bars and can always be considered a good time",
  "author", "chaddpaul",
  "region", "LES"
  )
redis.lpush("bar_ids",id)

id = redis.incr("bar_id")
redis.hmset(
  "bar:#{id}",
  "name", "The Wren",
  "location", "3rd and Bowery",
  "picture", "http://katesdougherty.files.wordpress.com/2012/01/the-wren-02.jpg",
  "text", "The wren is a smaller venue but in small things come great packages. It is a vibrant young crowd and a very happy atmosphere",
  "author", "chaddpaul",
  "region", "LES"
  )
redis.lpush("bar_ids",id)

id = redis.incr("bar_id")
redis.hmset(
  "bar:#{id}",
  "name", "Bailey's Pub",
  "location", "85th and york",
  "picture", "http://www.greendougherty.com/yorkville/Bailey's%20Bar.jpg",
  "text", "I quite rangers / sports bar with darts cheep beer and an easy ability to get drinks from the bartender",
  "author", "chaddpaul",
  "region", "UES"
  )
redis.lpush("bar_ids",id)

id = redis.incr("bar_id")
redis.hmset(
  "bar:#{id}",
  "name", "The Gin Mill",
  "location", "83rd and amsterdam",
  "picture", "http://cbsnewyork.files.wordpress.com/2012/08/the-gin-mill.jpg",
  "text", "A small but vibrant bar full of atmosphere and good food",
  "author", "chaddpaul",
  "region", "UWS"
  )
redis.lpush("bar_ids",id)

id = redis.incr("bar_id")
redis.hmset(
  "bar:#{id}",
  "name", "Cocktail's and Dreams",
  "location", "80th and broadway",
  "picture", "http://www.cnlegalnews.com/wp-content/uploads/2014/12/cocktails-and-dreams2.jpg",
  "text", "The real birth place of the NYC bar scene. It can't be beat or even compared to.",
  "author", "chaddpaul",
  "region", "UWS"
  )
redis.lpush("bar_ids",id)
