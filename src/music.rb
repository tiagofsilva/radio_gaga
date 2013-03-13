class Music 
  
  attr_accessor :title, :author, :album, :style
  
  def initialize title, author='', album='', style=''
    @title, @author, @album, @style = title, author, album, style
  end 
  
  def ==(music)
    self.title == music.title && self.author == music.author && self.album == music.album && self.style == music.style
  end
  
end