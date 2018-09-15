class ShortenedLink < ApplicationRecord
    UNIQUE_KEY_LENGTH = 5
    PREFIX = "http://localhost:3000/s/"

    # Validation
    validates :name, :original_url, :unique_key, :shortened_url, :hit_count, presence: true
    validates :original_url, uniqueness: {:case_sensitive => false, :message => ERROR_MSG[:LINK_EXIST]}
  
    # Check if shortened link exist
    def self.link_exist(orginial_url)
      !ShortenedLink.find_by_original_url(orginial_url).nil?
    end

    # Sanitize url
    def self.sanitize(url)
      url.strip!
      sanitized_url = url.downcase.gsub(/(https?:\/\/)|(www\.)/, "")
      sanitized_url = "http://#{sanitized_url}"
    end

    # Validate params and save it
    def self.validate_and_save(params)
      name = params[:name].strip
      original_url = params[:original_url].strip
      is_created = false
      message = ''

      if name.empty? || original_url.empty?
          message = ERROR_MSG[:EMPTY_DATA]
      else
          sanitized_url = sanitize(original_url)
          
          if !url_valid?(sanitized_url)
              message = ERROR_MSG[:INVALID_URL]
          elsif link_exist(sanitized_url)
              message = ERROR_MSG[:LINK_EXIST]
          else
              if generate(name, sanitized_url)
                  is_created = true
                  message = SUCCESS_MSG[:LINK_CREATED]
              else
                  message = ERROR_MSG[:ERROR]
              end
          end
      end
      [is_created, message]
    end

    # Generate short url and save it
    def self.generate(name, original_url)
      # Iterate until a unique key is found
      begin
        unique_key = self.generate_random_string(UNIQUE_KEY_LENGTH)
      end while ShortenedLink.find_by_unique_key unique_key
  
      sl = ShortenedLink.new
      sl.name = name
      sl.original_url = original_url
      sl.unique_key = unique_key
      sl.shortened_url = shortened_url(unique_key)
      sl.save
    end

    # Validate url
    def self.url_valid?(url)
      url = URI.parse(url) rescue false
      url.kind_of?(URI::HTTP) || url.kind_of?(URI::HTTPS)
    end 
  
    private
    # Returns shortened url from unique key
    def self.shortened_url(unique_key)
      PREFIX + unique_key
    end
  
    # generate a random string
    def self.generate_random_string(size)
      charset = ('a'..'z').to_a + (0..9).to_a
      (0...size).map{ charset.to_a[rand(charset.size)] }.join
    end
end