require 'imgur'

module ImgurRails

  def acts_as_imgur_image
    attr_accessor :image_data
    
    before_create do
      response = Imgur.upload :filename => self.image_data.tempfile.path
      self.image_hash = response[:image_hash]
      self.delete_hash = response[:delete_hash]
    end
    
    before_destroy { Imgur.delete self.delete_hash if self.delete_hash }
    
    include InstanceMethods
    
  end
  
  module InstanceMethods
  
    def is_image?
      true
    end
    alias_method :is_imgur_image?, :is_image?
    
  end

end

ActiveRecord::Base.extend ImgurRails
