require_relative 'spec_helper'

describe Playlist do
  
  before :all do
     
    @redis = Redis.new
     
    @songs_arr = [
      Music.new("Pigeon knows", "Tiny ruins", "Tiny ruins", :folk),
      Music.new("Livin on a prayer", "Bon Jovi", "Greatest hits", :rock),
      Music.new("Zero", "Smashing Pumpkins", "Mellon Collie", :rock)
    ]
    
    File.open "resources/playlist.yaml", "w" do |f|
      f.write YAML::dump @songs_arr
      f.close
    end
    
  end
  
  before :each do
    @playlist = Playlist.new "list", @songs_arr
  end
  
  after :all do
    @redis.flushall
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
  
  describe "#persist" do
    it "initializes playlist in redis and provides a redis id if it does not have one" do
      id = @playlist.id
      id.should_not be_nil 
    end
  end
  
  describe "#songs" do
    it "get all songs from the playlist" do
      @playlist.songs.should == @songs_arr
    end
  end
  
  describe "#add" do
    context "when receives only one music as parameter" do
      it "adds a song to the playlist" do
        @playlist.add(Music.new "40", "U2", "War", :rock)
        @playlist.songs.should_not == @songs_arr
        @playlist.songs.size.should eql 4
      end  
    end
    
    context "when receives a list of musics as param" do
      it "adds list of 1 song to the playlist" do
        new_songs = [Music.new("Jaded", "Aerosmith", "", :rock)]
        @playlist.add new_songs
        @playlist.songs.should == @songs_arr + new_songs            
      end
      
      it "adds 3 songs to the playlist" do
        new_songs = [Music.new("Jaded", "Aerosmith", "", :rock),
                    Music.new("Karen", "The National", "Cherry Tree", :indie),
                    Music.new("Toxicity", "SOAD", "Toxicity", :rock)]
        @playlist.add new_songs
        @playlist.songs.should ==  @songs_arr + new_songs            
      end
    end
    
    context "when receives nil" do
      it "does not add music" do
        expect {@playlist.add nil}.not_to raise_exception
        @playlist.add nil
        @playlist.size.should eql 3
      end
    end
    
  end
  
  describe "#find_by" do
    context "when looking for a song by title only" do
      it "finds one song matching description" do
        music = @playlist.find_by :title => "Pigeon knows"
        music.first.should == @songs_arr.first
      end
    end
    
    context "when looking for a song by author only" do
      it "finds one song matching description" do
        music = @playlist.find_by :author => "Bon Jovi"
        music.first.should == @songs_arr[1]
      end
    end
    
    context "when looking for a song by style only" do
      it "finds more than one song matching description" do
        musics = @playlist.find_by :style => :rock
        musics.should == [@songs_arr[1], @songs_arr[2]]
      end
    end
    
    context "when looking for a song by more than one attribute" do
      it "finds one or more song matching description" do
        musics = @playlist.find_by :author => "Smashing Pumpkins", :style => :rock
        musics.first.should == @songs_arr[2]
      end
    end
    
  end
  
  describe "#remove_by" do
    context "when one existing attribute is passed" do
      it "removes the music from the playlist" do
        music_before = @playlist.find_by :title => "Zero"
        @playlist.remove_by :title => "Zero"
        music_after = @playlist.find_by :title => "Zero"
        music_before.first.title.should eql "Zero"
        music_after.should be_empty
      end
      
    end
    
    context "when a non existing attribute is passed" do
      it "does not remove the song from the playlist" do
        expect {@playlist.remove_by :theme => "Zero"}.to raise_exception
      end
    end
    
    context "when more than one song is selected" do
      it "removes all selected songs" do
        selected = @playlist.remove_by :style => :rock
        @playlist.songs.should have(1).items
        selected.should have(2).items
      end
    end
    
    context "when more than one attribute is passed" do
      it "removes all selected songs from playlist" do
        selected = @playlist.remove_by :title=>"Zero", :style => :rock
        @playlist.songs.should have(2).items
        selected.should have(1).items
      end
    end
    
  end
  
    
  
end
