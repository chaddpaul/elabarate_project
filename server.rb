module BarApp
  class Server < Sinatra::Base

    use Rack::MethodOverride

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
      @bars_by_region = bars_by_region

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
        "name",      params["name"],
        "location",  params["location"],
        "picture",   params["picture"],
        "text",      params["text"],
        "region",    params["region"],
        "author",    params["author"],
        "timestamp", DateTime.now.to_s
      )
      $redis.lpush("bar_ids",id)
      redirect to('/home')
    end
# ///////////////////END POST////////////////////////

# ////////////////START DELETE///////////////////////
    delete('/home/b/:name') do
      delete_bar bar_list[params[:name]]
      redirect to('/home')
    end

    def bar(id)
      $redis.hgetall("bar:#{id}")
    end

    def bar_ids
      $redis.lrange("bar_ids",0,-1)
    end

    def bar_name(id)
      $redis.hget "bar:#{id}", "name"
    end

    def bar_list
      bar_ids.map {|id| [bar_name(id), id] }.to_h
    end

    def delete_bar(id)
      # delete the value
      $redis.del("bar:#{id}")
      # delete from list of keys
      $redis.lrem("bar_ids",0,id)
    end

    def bars
      bar_ids.map {|id| bar(id)}
    end

    def bars_by_region
      bars_by_region = bars.group_by {|bar| bar["region"]}

      # sort each array of bars by their timestamps
      bars_by_region.each do |region, bars|
        sorted_bar_list = bars.sort_by { |bar| bar["timestamp"] }
        # now, replace the current regions list of bars by the sorted list version
        bars_by_region[region] = sorted_bar_list.reverse
      end
    end



  end
end
