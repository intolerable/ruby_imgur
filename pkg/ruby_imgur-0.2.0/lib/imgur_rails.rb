require 'imgur'

module ImgurRails

  def acts_as_imgur_image
    attr_accessor :image_data
    
    before_create do
      response = Imgur.upload :filename => self.image_data.tempfile.path
      self.image_hash = response[:hash]
      self.delete_hash = response[:delete_hash] if self.respond_to? :delete_hash
      self.filetype = response[:filetype] if self.respond_to? :filetype
    end
    
    before_destroy do
      Imgur.delete self.delete_hash if self.respond_to? :delete_hash
    end
    
    include InstanceMethods
    
  end
  
  module InstanceMethods
  
    def url
      type = ( self.respond_to? :filetype ) ? self.filetype : :detect
      Imgur.url_for self.image_hash, :filetype => type
    end
    
    def thumbnail( size = :small )
      type = { :small => :jpeg, :medium => :jpg }[size]
      Imgur.url_for self.image_hash, :filetype => type, :size => size
    end
  
    def is_image?
      true
    end
    alias_method :is_imgur_image?, :is_image?
    
  end

end

ActiveRecord::Base.extend ImgurRails
