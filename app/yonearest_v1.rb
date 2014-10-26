require 'rubygems'
require 'grape'
require 'json'

require 'open-uri' #for https googly request
require 'net/https'

#you need to add a file in this directory containing YoToken and GoogleToken
require 'tokens.rb'

def SendAtYo(user, lat, lng)
  location = lat.to_s+';'+lng.to_s
  postData = Net::HTTP.post_form(URI.parse('http://api.justyo.co/yo/'), {'api_token'=>YoToken, 'username'=>user, 'location'=>location})
end

def AddParam(url, param_name, param_value)
  uri = URI(url)
  params = URI.decode_www_form(uri.query.to_s) << [param_name, param_value]
  uri.query = URI.encode_www_form(params)
  uri.to_s
end


#================================
class YoNearestV1 < Grape::API  
  version 'v1', :using => :path, :vendor => 'YoGetNearest'
  error_format :json
    
  resource :loc do          
    get ":placetype" do  
      # We need this code to disentangle the lat;lng separated by a semicolon in the Yo API
      location = Rack::Utils.parse_nested_query(env['QUERY_STRING'], '&')['location']
      coordinates = location.split(';')
                                  
      # All this is for googly HTTPS
      url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json"
      url = AddParam(url, 'key', GoogleToken)
      url = AddParam(url, 'location', coordinates[0].to_s + ',' + coordinates[1].to_s)
      url = AddParam(url, 'rankby', 'distance')
      url = AddParam(url, 'types', params[:placetype])

      result = URI.parse(url).read
      
      # Extract the data we want from the JSON      
      hash = JSON.parse result
      obj = Hashie::Mash.new hash
      
      # send appropriate data to Yo user
      if (not obj.results.empty?)      
        location = obj.results[0].geometry.location;      
        SendAtYo(params['username'], location.lat, location.lng)   
      end   
      
    end
  end
end
