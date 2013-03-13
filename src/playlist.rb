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
    
    commit
      
  end
  
  def empty?
    @songs.empty?
  end
  
private  
  def commit
    @redis = Redis.new
    @id = @redis.incr "#{self.class.name.downcase}:id" 
    @redis.hset "#{self.class.name.downcase}", "id", @id
  end
  
end