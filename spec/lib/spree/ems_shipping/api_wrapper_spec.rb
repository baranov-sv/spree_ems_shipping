require File.dirname(__FILE__) + '/../../../spec_helper'

describe "Spree::EmsShipping::ApiWrapper" do

  def should_be_fail(result)
    result.kind_of?(Hash).should be_true
    result.kind_of?(Hash)
    result.include?('code').should be_true
    result.include?('msg').should be_true
  end 

  before :each do
    @wrapper = Spree::EmsShipping::ApiWrapper.new(Spree::EmsShipping::Config[:api_url])
  end

  describe "ApiWrapper::normalize_location_name" do
    it "returns empty string for nil" do
      Spree::EmsShipping::ApiWrapper::normalize_location_name(nil).should be_empty
    end
    example "non unicode" do
      name = '  TverSkoy   RegiOn  '
      normalized_name = 'TVERSKOY REGION'
      (Spree::EmsShipping::ApiWrapper::normalize_location_name(name) == normalized_name).should be_true
    end
    example "unicode example" do
      name = "    \320\242\320\262\320\265\320\240\321\201\320\232\320\260\321\217    \320\236\320\261\320\273\320\260\320\241\321\202\321\214    " # "    ТвеРсКая    ОблаСть    "
      normalized_name = "\320\242\320\222\320\225\320\240\320\241\320\232\320\220\320\257 \320\236\320\221\320\233\320\220\320\241\320\242\320\254" # "ТВЕРСКАЯ ОБЛАСТЬ"
      (Spree::EmsShipping::ApiWrapper::normalize_location_name(name) == normalized_name).should be_true
    end
  end

  describe "max_weight" do
    it "returns  max_weight" do
      result = @wrapper.max_weight
      result.kind_of?(Float).should be_true
    end
  end

  describe "locations" do
    it "returns locations array if parameter type correct" do
      result = @wrapper.locations("cities")
      result.kind_of?(Array).should be_true
      location = result.first
      location.kind_of?(Hash).should be_true
      location.include?('value').should be_true
      location.include?('name').should be_true
      location.include?('type').should be_true
    end

    it "returns hash with state and error hash when parameter type incorrect" do
      result = @wrapper.locations("unknown")
      should_be_fail(result)
    end
  end

  describe "calculate" do
    it "returns price when set of params correct" do
      result = @wrapper.calculate({"from" => "city--tver","to" => "region--omskaja-oblast", "weight" => "1"})
      result.kind_of?(Float).should be_true
    end

    it "returns hash with state and error hash when set of params incorrect " do
      result = @wrapper.calculate({"to" => "region--omskaja-oblast", "weight" => "1"})
      should_be_fail(result)
    end

    it "returns hash with state and error hash when shipping impossible" do
      result = @wrapper.calculate({"from" => "city--tver22222","to" => "region--omskaja-oblast", "weight" => "1"})
      should_be_fail(result)
    end
  end

  describe "error_wrap" do
    it "raise Spree::EmsShipping::ApiWrapperError if something wrong with api" do      
      expect { Spree::EmsShipping::ApiWrapper.new(nil).max_weight }.to raise_error(Spree::EmsShipping::ApiWrapperError)
    end
  end
end