module BarApp
  class Server < Sinatra::Base

    configure :development do
      register Sinatra::Reloader
      require 'pry'
      $redis = Redis.new
    end

# //////////////START Original Get//////////////////
    get('/') do
      redirect to('/home')
    end
# ///////////////////END Original get///////////////

# ////////////////START HOME////////////////////////
    get('/home') do
      ids = $redis.lrange("bar_ids",0,-1)
      @bars = ids.map do |id|
        $redis.hgetall("bar:#{id}")
      end
      render(:erb,:index,{:layout => :default_layout})
    end
# ///////////////////END HOME//////////////////////

# ////////////////START NEW////////////////////////
    get('/home/new') do
      render(:erb,:new)
    end
# ///////////////////END NEW////////////////////////

# ////////////////START REGION//////////////////////
    get('/home/r/:region') do
      ids = $redis.lrange("bar_ids",0,-1)
      @region = []
      ids.each do |id|
        if $redis.hget("bar:#{id}","region")== params[:region]
          @region.push($redis.hgetall("bar:#{id}"))
        end
      end
      render(:erb,:show_region,{:layout => :default_layout})
    end
# ///////////////////END REGION/////////////////////

# ////////////////START BAR/////////////////////////
    get('/home/b/:bar') do
      ids = $redis.lrange("bar_ids",0,-1)
      reference_id = ids.select do |id|
        $redis.hget("bar:#{id}","name")== params[:bar]
      end
      @bar = $redis.hgetall("bar:#{reference_id.join}")
      render(:erb,:show_bar,{:layout => :default_layout})
    end
# ///////////////////END BAR////////////////////////

# ////////////////START POST////////////////////////
    post('/home') do
      id = $redis.incr("bar_id")
      $redis.hmset(
        "bar:#{id}",
        "name", params["name"],
        "location", params["location"],
        "picture", params["picture"],
        "text", params["text"],
        "region", params["region"],
        "author", params["author"]
        )
      $redis.lpush("bar_ids",id)
      redirect to('/home')
    end
# ///////////////////END POST////////////////////////
  end
end
