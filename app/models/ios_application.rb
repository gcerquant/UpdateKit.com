require 'hpricot'
require 'open-uri'

require 'active_support' # I want to be able to use .try()

class IosApplication < ActiveRecord::Base
  
  require 'devise'
  
  belongs_to :user
  
  # Valid id 359 435 914
  
   extend ActionView::Helpers::UrlHelper
   extend ActionView::Helpers::TagHelper
  
  validates :application_bundle_identifier,
    :format => {
      :with => /^[a-zA-Z0-9.-]+$/,
        :message => "A bundle identifier is required and should contain only alphanumeric (A-Z, a-z, 0-9), hyphen (-), and period (.) characters."
      }
        
#{view_contex.link_to "source" contact_path  }
        
        # :message => lambda {"some text followed by a link #{link_to "Link to SO", "http://stackoverflow.com" }"}
  # http://developer.apple.com/library/ios/#documentation/CoreFoundation/Conceptual/CFBundles/AboutBundles/AboutBundles.html#//apple_ref/doc/uid/10000123i-CH100-SW4
        
        
  validates :apple_identifier, :format => {
      :allow_blank => true,
      :with => /\A[0-9]{9}\z/,
        :message => "An AppleID should contain only exactly 9 digits. Find your AppleID on iTunes Connect." }
  
    def self.search(search)
      if search
        find(:all, :conditions => ['title LIKE ? OR application_bundle_identifier LIKE ? OR apple_identifier LIKE ?', "%#{search}%", "%#{search}%", "%#{search}%"])
      else
        find(:all)
      end
    end
  
    def owner
      return self.user
    end
    
    def is_owned_by(me)
      return owner == me && (! me.nil? )
    end
  
    def protected_by_owner?
      return self.user
    end
    
    
    def update_url
      # TODO: Here I should add the itms protocol:
      # itms-services://?action=download-manifest&url=...
      # And user should only link toward an ipa, not a manifest (makes it easier)
      manual_version_management ? custom_published_url : "http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftwareUpdate?id=#{apple_identifier}&mt=8"
    end
    
    # TODO: Can be on the AppStore, or just local
    def product_url
      # TODO A tester here!
      manual_version_management ? custom_published_url : "http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=#{apple_identifier}&mt=8"
    end
    
    
    def self.update_all_applications_version_number
      IosApplication.find(:all, :conditions => { :manual_version_management => false }).each do |ios_application|
        puts "Getting version number for: #{ios_application.application_bundle_identifier}"
        ios_application.fetch_version_number_from_apple_server
      end
    end

    def self.update_all_applications_information_from_apple
      IosApplication.find(:all).each do |ios_application|
        ios_application.fetch_application_information_from_apple_api
      end
    end
    
    
    def fetch_application_information_from_apple_api
      puts "Fetching info for #{application_bundle_identifier} using Apple API."
      url = "http://ax.itunes.apple.com/WebObjects/MZStoreServices.woa/wa/wsLookup?bundleId=#{application_bundle_identifier}"
      begin
        json = open url
      rescue
        # a multitude of HTTP-related errors can occur
      end

      json_string = json.read
      
      application_information = ActiveSupport::JSON.decode(json_string)
      
      if (application_information['resultCount'] == 1) 
        self.icon_small_url = application_information['results'][0]['artworkUrl60']
        self.icon_url = application_information['results'][0]['artworkUrl512']
        
        self.save
        
      else
        puts "Unexpected number of result in API search\nUrl request: #{url}\nResult: #{application_information}\n"
      end
      
    end
    
    
    def fetch_version_number_from_apple_server
      # TODO: The call below is only temporary. Finish the job
      fetch_application_information_from_apple_api()
      
      if apple_identifier.nil?
        return :alert => "Unable to fetch version number because AppleID is not specified"
      end

      if manual_version_management
        return :alert => "It is not possible to fetch the version number of a manually managed application"
      end

      if apple_identifier.nil? || apple_identifier == ""
        return :alert => "It is not possible to fetch the version number of an application without an AppleID"
      end

      url_of_application_on_app_store = "http://itunes.apple.com/app/id" + apple_identifier + "?mt=8"
      # puts "URL: #{url_of_application_on_app_store}"




      # Get a Nokogiri::HTML:Document for the page we’re interested in...
      # doc = Nokogiri::HTML(open('http://itunes.apple.com/fr/app/tictacboo-new-rule-for-tictactoe/id359435914?mt=8'))
      doc = open(url_of_application_on_app_store) { |f| Hpricot(f) }
      # puts "My doc: #{doc}"

      if doc.nil?
        return :alert => "Unable to download application page from Apple"
      end

      mydiv = doc.search("div[@id=left-stack]").try(:first)
      # puts "MY DIV:\n #{mydiv}"


      if (mydiv.nil?)
        return :alert => "Did not find the div containing the information about the application"
      end
      # puts "My div: '#{mydiv}' - #{mydiv.nil?} - #{mydiv == ""}"
      
      myul = mydiv.search("ul[@class=list]").first
      # puts "MY UL : #{myul}"


      html_element = myul.search("li").at(3)

      if html_element.nil?
        return :alert => "Unable to parse version number from Apple"
      end

      fetched_version_number = html_element.inner_html
      fetched_version_number.slice! '<span class="label">Version : </span>'
      fetched_version_number.slice! '<span class="label">Version: </span>'

      self.published_version_number = fetched_version_number

      puts "Got version number: #{published_version_number}"
      if (self.save)
        return :notice => "Updated version number from AppStore (#{fetched_version_number})"
      else
        return :alert => "Fetched version number from AppStore (#{fetched_version_number}), but unable to save it."
      end
    
    end
    
end
