class Music 
  
  attr_accessor :title, :author, :album, :style
  
  def initialize title, author='', album='', style=''
    @title, @author, @album, @style = title, author, album, style
  end 
  
end