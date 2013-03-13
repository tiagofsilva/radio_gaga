require_relative 'spec_helper'

describe Playlist do
  
  before :all do
     
    @redis = Redis.new
     
    @songs_arr = [
      Music.new("Pigeon knows", "Tiny ruins", "Tiny ruins", :folk),
      Music.new("Livin on a prayer", "Bon Jovi", "Greatest hits", :rock),
      Music.new("Smashing Pumpkins", "Zero", "Mellon Collie", :rock)
    ]
    
    File.open "resources/playlist.yaml", "w" do |f|
      f.write YAML::dump @songs_arr
      f.close
    end
    
  end
  
  before :each do
    @playlist = Playlist.new "list", @songs_arr
  end
 
  
  describe "#new" do
    context "with no songs in it" do
      it "returns an empty playlist" do
        list = Playlist.new "example"
        list.empty?.should be_true 
      end
    end
    
    context "with no params" do
      it "raises an exception" do
        expect {Playlist.new}.to raise_exception ArgumentError
      end
    end
    
    context "with name and an array of songs" do
      it "returns a playlist object" do
        playlist = Playlist.new "example", @songs_arr
        playlist.empty?.should be_false
        playlist.songs.length.should eql 3
      end
    end
    
    context "with name and a yaml file" do
      it "returns same list of songs in init array" do
        playlist = Playlist.new "example", "resources/playlist.yaml"
        playlist.songs.should == @songs_arr
      end
    end
    
    context "with name and an inexistent yaml file" do
      it "raises an exception" do
        expect {Playlist.new "example", "resources/play.yaml"}.to raise_exception 
      end
    end
  end
  
  describe "#commit" do
    it "initializes playlist in redis and provides a redis id if it does not have one" do
      id = @playlist.id
      id.should_not be_nil 
    end
  end
  
end
