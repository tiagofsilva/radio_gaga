require 'yaml'
require 'redis'

class Playlist
  
  attr_accessor :name, :songs
  attr_reader :id
  
  def initialize name, songz = []
    @name = name
    if songz.is_a? Array then persist songz
     elsif songz.is_a? String then persist(YAML::load File.read(songz))
    end
    
  end
  
  def size
    songs.size
  end
  
  def songs
    YAML::load(@redis.hget redis_id, "songs")
  end
  
  
  def empty?
    songs.empty?
  end
  
  def add music
    if music.nil? then return false end
    songz = songs
    songz << music
    @redis.hset redis_id, "songs", YAML::dump(songz.flatten) 
  end
  
  
  def find_by options = {}
    filtered = songs
    options.each do |key, val|
      filtered.select! {|song| eval("song.#{key}") == val}  
    end 
    return filtered.size == 1? filtered.first : filtered 
  end
  
  def remove_by options = {}
   all_songs = songs 
   selected = find_by options
   all_songs.delete selected
   @redis.hset redis_id, "songs", YAML::dump(all_songs.flatten)
   return selected
  end
  
  
private  
  def persist songz
    @redis = Redis.new
    @id = @redis.incr "#{self.class.name.downcase}:id" 
    @redis.hset "#{self.class.name.downcase}", "id", @id
    @redis.hset redis_id, "songs", YAML::dump(songz)
  end
  
  def redis_id
    "#{self.class.name.downcase}:#{@id}"
  end
  
end