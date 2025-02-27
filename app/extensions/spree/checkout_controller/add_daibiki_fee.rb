module Spree
  class CheckoutController < Spree::StoreController
    module AddDaibikiFee
      def self.prepended(base)
        base.before_action :apply_daibiki_fee, only: :update
        base.after_action :destroy_checkout_invalid
        base.after_action :assure_accurate_totals
      end

      private

      def prior_adjustment?
        current_order.adjustments.map(&:label).include?(@label)
      end

      def apply_daibiki_fee
        return unless params[:state] == 'payment' && params[:order]

        # Lazy but we're just going to assume that there's only one of these payment method types
        @daibiki = Spree::PaymentMethod::Daibiki.first
        @label = @daibiki.name
        remove_daibiki_fee_adjustment # Reset any daibiki adjustments
        add_daibiki_fee_adjustment # Add fees for daibiki if needed
        # Update totals (manually load order to get the new adjustments and clear cache)
        Spree::Order.find(current_order.id).recalculate
      end

      def remove_daibiki_fee_adjustment
        current_order.adjustments.where(label: @label).destroy_all
      end

      def add_daibiki_fee_adjustment
        # Add the adjustment if it's not there, and the payment method is daibiki
        params[:order][:payments_attributes].each do |payment|
          next if payment[:payment_method_id] != @daibiki.id.to_s

          Rails.logger.info "Adding daibiki shipping fee to order ##{current_order.number}"
          daibiki_fee_adjustment
        end
      end

      def calculate_daibiki_fee
        pref = @daibiki.preferences
        current_order.total.to_i > pref[:daibiki_over_amount] ? pref[:daibiki_fee_big] : pref[:daibiki_fee]
      end

      def daibiki_fee_adjustment
        # Only need to apply this fee once even if there were multiple packages
        current_order.adjustments.create!(
          amount: calculate_daibiki_fee,
          label: @label,
          adjustable_type: current_order.class.name,
          adjustable_id: current_order.id,
          order_id: current_order.id,
          source_type: @daibiki.class.name,
          source_id: @daibiki.id
        )
      end

      def assure_accurate_totals
        # Assure that the new order total is applied to the payment method amount
        return unless current_order

        current_order&.payments&.each do |payment|
          payment.update(amount: current_order.total)
        end
      end

      def destroy_checkout_invalid
        # Remove any invalid payments, useless information if the payment method has changed during checkout
        return unless current_order

        current_order&.payments&.where(state: 'invalid')&.destroy_all
      end

      ::Spree::CheckoutController.prepend self
    end
  end
end
