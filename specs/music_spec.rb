require_relative 'spec_helper'

describe Music do
  
  before :each do
    @music = Music.new 'Murder me Rachel', 'The National', 'Alligator', :indie_rock
  end

  
  describe "#new" do
    context "Receives all params" do
      it  "returns Music object" do
        @music.should be_an_instance_of Music
      end 
    end
    
    context "When receives only title" do
      it "returns Music object" do
        music = Music.new 'Murder me Rachel'
        music.should be_an_instance_of Music
        music.title.should eql 'Murder me Rachel'
      end
    end
    
    context "When receives no params" do
      it "raises exception" do
        expect {Music.new}.to raise_exception ArgumentError  
      end
    end
    
    describe "#title" do
      it "should return the correct title" do
        @music.title.should eql "Murder me Rachel"
      end  
    end
    
    describe "#author" do
      it "should return the correct author" do
        @music.author.should eql "The National"
      end  
    end  
    
    describe "#album" do
      it "should return the correct album" do
        @music.album.should eql "Alligator"
      end  
    end
    
    describe "#style" do
      it "should return the correct style" do
        @music.style.should eql :indie_rock
      end
    end
        
  end
  
  
  
end 
