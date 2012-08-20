require 'securerandom'

module SpreeEmsShipping
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("../../templates", __FILE__)

      desc "Creates a Devise initializer."

      def copy_initializer
        template "spree_ems_shipping.rb", "config/initializers/spree_ems_shipping.rb"
      end
    end
  end
end
