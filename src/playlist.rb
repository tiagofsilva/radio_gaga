require 'yaml'
require 'redis'

class Playlist
  
  attr_accessor :name, :songs
  attr_reader :id
  
  def initialize name, songs = []
    @name = name
    if songs.is_a? Array then @songs = songs
     elsif songs.is_a? String then @songs = YAML::load File.read(songs)
    end
    
    persist
      
  end
  
  def size
    @songs.size
  end
  
  def add music
    songs = @songs.dup
    songs << music
    @redis.hset redis_id, "songs", YAML::dump(songs.flatten) 
  end
  
  def find_by options = {}
    songs = @songs.dup
    options.each do |key, val|
      songs.select! {|song| eval("song.#{key}") == val}  
    end 
    return songs.size == 1? songs.first : songs 
  end
  
  def songs
    result = YAML::load(@redis.hget redis_id, "songs")
  end
  
  
  def empty?
    @songs.empty?
  end
  
private  
  def persist
    @redis = Redis.new
    @id = @redis.incr "#{self.class.name.downcase}:id" 
    @redis.hset "#{self.class.name.downcase}", "id", @id
    @redis.hset redis_id, "songs", YAML::dump(@songs)
  end
  
  def redis_id
    "#{self.class.name.downcase}:#{@id}"
  end
  
end