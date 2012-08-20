require 'open-uri'
require 'json'

module Spree
 module EmsShipping

    class ApiWrapperError < RuntimeError; end

     # Class to wrap access to EMS Russian Post api.
    class ApiWrapper
      attr_reader :api_url

      def initialize(api_url)
        super()
        @api_url = api_url
      end

      # Wrap block calling
      # Intercept ApiWrapper errors and raise ApiWrapperError instead of.
      def error_wrap(&block)
        yield block  
      rescue Exception => e
        raise ApiWrapperError.new(e.message)
      end

      private :error_wrap

      # Wrap method  ems.get.max.weight.
      # Return max_weight if response state is ok.
      # Return err hash if  response state is fail.
      def max_weight
        rsp = error_wrap{JSON.parse(open("#{api_url}?method=ems.get.max.weight").read)}['rsp']
        if rsp['stat'] == Spree::EmsShipping::Constants::RESPONSE_STATE_OK
          return rsp['max_weight'].to_f
        else
          return rsp['err']
        end  
      end
      
      # Wrap method ems.calculate
      # Expects a hash of options -  :from, :to, :weight, :type
      # Convert response to hash
      def calculate(opts)
        params = ""
        opts.each do |key,value|
          params << "&#{key}=#{value}"
        end
        #   
        rsp = error_wrap{JSON.parse(open("#{api_url}?method=ems.calculate#{params}").read)}['rsp']
        if rsp['stat'] == Spree::EmsShipping::Constants::RESPONSE_STATE_OK
          return rsp['price'].to_f
        else
          return rsp['err']
        end
      end

      # Wrap method ems.get.locations
      # Expects type of location
      # Return locations array if response state is ok.
      # Return err hash if response state is fail.
      def locations(type)
        rsp = error_wrap{JSON.parse(open("#{api_url}?method=ems.get.locations&type=#{type}&plain=true").read)}['rsp']
        if rsp['stat'] == Spree::EmsShipping::Constants::RESPONSE_STATE_OK
          return rsp['locations']
        else
          return rsp['err']
        end
      end
    end
  end
end  
