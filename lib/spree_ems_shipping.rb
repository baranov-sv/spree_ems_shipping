require 'spree_core'

module SpreeEmsShipping
  class Engine < Rails::Engine

    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), "spree/**/*.rb")) do |c|
        Rails.env.production? ? require(c) : load(c)
      end
      
      Dir.glob(File.join(File.dirname(__FILE__), "../app/models/calculator/*.rb")) do |c|
        Rails.env.production? ? require(c) : load(c)
      end

      [
        Calculator::EmsRussiaShipping
      ].each(&:register)

      Dir.glob(File.join(File.dirname(__FILE__), "../app/controllers/*_decorator*.rb")) do |c|
        Rails.env.production? ? require(c) : load(c)
      end
    end


    config.autoload_paths += %W(#{config.root}/lib)
    config.to_prepare &method(:activate).to_proc
  end
end
