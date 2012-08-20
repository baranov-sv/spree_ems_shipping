module Spree
     # Singleton class to access the shipping configuration object (EmsShippingConfiguration.first by default) and it's preferences.
 module EmsShipping
    #
    # Usage:
    #   Spree::EmsShipping::Config[:foo]                  # Returns the foo preference
    #   Spree::EmsShipping::Config[]                      # Returns a Hash with all the tax preferences
    #   Spree::EmsShipping::Config.instance               # Returns the configuration object (EmsShippingConfiguration.first)
    #   Spree::EmsShipping::Config.set(preferences_hash)  # Set the active shipping preferences as especified in +preference_hash+
    class Config
      include Singleton
      include PreferenceAccess
    
      class << self
        def instance
          return nil unless ActiveRecord::Base.connection.tables.include?('configurations')
          EmsShippingConfiguration.find_or_create_by_name("Default ems_shipping configuration")
        end
      end
    end
  end
end