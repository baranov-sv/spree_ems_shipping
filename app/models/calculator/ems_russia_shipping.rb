require 'unicode'

# This is a calculator for shipping calculations in Russia only 
class Calculator::EmsRussiaShipping < Calculator

  def self.register
    super
    ShippingMethod.register_calculator(self)
  end

  def self.description
    "EMS in Russia"
  end

  def self.service_name
    self.description
  end

  attr_reader :api_wrapper, :rate

  def compute(order)
    return self.rate
  end

  def available?(order)
    @api_wrapper = Spree::EmsShipping::ApiWrapper.new(Spree::EmsShipping::Config[:api_url])
    # check order weight
    max_weight = api_wrapper.max_weight
    order_weight = get_total_weight(order)
    return false if max_weight.kind_of?(Hash) || order_weight == 0 || order_weight > max_weight
    # get ems destination
    order_destination = get_ems_destination(order)
    return false if order_destination.nil?
    # get price
    price = api_wrapper.calculate(:from => Spree::EmsShipping::Config[:origin_city], :to => order_destination, :weight => order_weight)
    unless price.kind_of?(Hash)
      @rate = price
      return true
    else
      @rate = nil
      return false 
    end
  rescue Spree::EmsShipping::ApiWrapperError => e
    raise Spree::EmsShippingError.new("#{I18n.t('ems_shipping_error')}: #{e.message}")
  end

   private

   # Return total weight of all order's line items.
   # If line item has no weight Spree::EmsShipping::Config[:weight_if_nil] used instead of.
   # Return 0 if anyone line item has weight 0. 
   def get_total_weight(order)
    return 0 unless order.present? and order.line_items.present?
    line_item_weights = order.line_items.map {|item| item.quantity * (item.variant.weight || Spree::EmsShipping::Config[:weight_if_nil])}
    if line_item_weights.include?(0)
      return 0
    else
      return line_item_weights.sum / 1000.00
    end
   end

   # Return destination ems point for order.
   # Return nil if destination is not found
   def get_ems_destination(order)
    return nil unless order.present?
    order_city = Unicode::upcase(order.ship_address.city.to_s).gsub(/\s+/,' ')
    order_region = Unicode::upcase(order.ship_address.state_name.to_s).gsub(/\s+/,' ')
    # search in cities
    cities = api_wrapper.locations('cities')
    return nil if cities.kind_of?(Hash)
    if ind = cities.index{|c| Unicode::upcase(c['name']) == order_city}
      return cities[ind]['value']
    end
    # search in regions
    regions = api_wrapper.locations('regions')
    return nil if regions.kind_of?(Hash)
    if ind = regions.index {|r| Unicode::upcase(r['name']) == order_region}
      return regions[ind]['value'] 
    end
    # if we are here it means destination is not found
    return nil
   end

end
