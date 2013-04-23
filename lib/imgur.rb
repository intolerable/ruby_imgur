require 'httpclient'
require 'json'
require 'base64'

class Imgur
  
  ImgurException = Class.new Exception
  
  IMAGE_SIZES = { :small => :s, :medium => :m, :large => :l }
  
  # Set Imgur client ID - get it from http://imgur.com/account/settings/apps
  #
  # @param client_id [String] the Imgur API client ID
  # @return [String]
  def self.client_id=( client_id )
    @@client_id = client_id
  end
  
  # @param options Hash{}
  # @return [Hash] keys `:hash`, `:delete_hash`, `:filetype`
  def self.upload( options = {} )
    data = options[:data] ||
      options[:url] ||
      Base64.encode64(open(options[:filename]).read)
    post_data = { :image => data }
    post_url = generate_url :method => :upload
    response = JSON http.post(post_url, post_data, header).body
    raise ImgurException.new response["data"]["error"] if response["data"]["error"]
    { :hash => response["data"]["id"],
      :delete_hash => response["data"]["deletehash"],
      :filetype => response["data"]["link"].match(/\.(\w*)\Z/)[1] }
  end
  
  def self.copy( url )
    upload :url => url
  end
  
  def self.upload_file( filename )
    upload :filename => filename
  end
  
  def self.get( hash, options = {} )
    http.get_content url_for hash, options
  end
  
  def self.delete( delete_hash )
    url = generate_url :hash => delete_hash, :method => :image 
    response = JSON http.delete( url, {}, header ).body
    response["success"] == true
  end
  
  def self.url_for( hash, options = {} )
    size = IMAGE_SIZES[options[:size].to_sym] if options[:size]
    filetype = options[:filetype] || :png
    if filetype == :detect
      filetype = json_get( :hash => hash, :method => :image )["data"]["link"].match(/\.(\w*)\Z/)[1]
    end
    "http://i.imgur.com/#{hash}#{size}.#{filetype}"
  end
  
  private
  
  def self.header
    { "Authorization" => "Client-ID #{@@client_id}" }
  end
  
  def self.json_get( options = {} )
    response = JSON http.get_content generate_url(options), {}, header
    raise ImgurException.new response["data"]["error"] if response["data"]["error"]
  end
  
  def self.generate_url( options = {} )
    hash = options[:hash]
    method = options[:method]
    url = "https://api.imgur.com/3/"
    url += method.to_s
    url += "/" + hash.to_s if hash
    url += ".json"
  end
  
  def self.http
    @@http ||= HTTPClient.new
    @@http.ssl_config.verify_mode = OpenSSL::SSL::VERIFY_NONE
    @@http
  end
  
end
