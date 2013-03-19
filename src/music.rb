class Music 
  
  attr_accessor :title, :author, :album, :style
  
  def initialize title, author='', album='', style=''
    @title, @author, @album, @style = title, author, album, style
  end 
  
  def ==(music)
    @title == music.title && @author == music.author && @album == music.album && @style == music.style
  end
  
  
end