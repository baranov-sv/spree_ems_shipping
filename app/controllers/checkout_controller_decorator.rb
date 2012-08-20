# handle shipping errors gracefully during checkout
CheckoutController.class_eval do
  
  rescue_from Spree::EmsShippingError, :with => :handle_ems_shipping_error

  private
    def handle_ems_shipping_error(e)
      flash[:error] = e.message
      redirect_to checkout_state_path(:address)
    end
end