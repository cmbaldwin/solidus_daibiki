# Spree::CheckoutController.class_eval do

#   before_action :pay_on_delivery, only: :update

#   private

#   def pay_on_delivery
#     return
#     return unless params[:state] == 'payment'
#     return if params[:order].blank? || params[:order][:payments_attributes].blank?

#     pm_id = params[:order][:payments_attributes].first[:payment_method_id]
#     payment_method = Spree::PaymentMethod.find(pm_id)

#     binding.pry

#     @_payment = @order.payments.build(
#       payment_method_id: payment_method.id,
#       amount: @order.total,
#       state: 'checkout'
#     )
#     @order.update!

#     # if payment_method && payment_method.kind_of?(Spree::PaymentMethod::CashOnDelivery)
#     #   binding.pry
#     #   order_params = PayuOrder.params(@order, request.remote_ip, order_url(@order), payu_notify_url, order_url(@order))
#     #   response = OpenPayU::Order.create(order_params)

#     #   case response.status['status_code']
#     #   when 'SUCCESS'
#     #     redirect_to response.redirect_uri if payment_success(payment_method)
#     #   else
#     #     payu_error
#     #   end
#     # end

#   rescue StandardError => e
#     payu_error(e)
#   end

#   def payment_success(payment_method)
#     unless @_payment.save
#       flash[:error] = @_payment.errors.full_messages.join("\n")
#       redirect_to checkout_state_path(@order.state) and return
#     end

#     unless @order.next
#       flash[:error] = @order.errors.full_messages.join("\n")
#       redirect_to checkout_state_path(@order.state) and return
#     end

#     @_payment.pend!
#   end

#   def payu_error(e = nil)
#     @order.errors[:base] << "PayU error #{e.try(:message)}"
#     render :edit
#   end

# end
