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
  
  
    def owner
      return self.user
    end
  
    def protected_by_owner?
      return self.user
    end
    
    
    def update_url
      manual_version_management ? custom_published_url : "http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftwareUpdate?id=#{apple_identifier}&mt=8"
    end

end
