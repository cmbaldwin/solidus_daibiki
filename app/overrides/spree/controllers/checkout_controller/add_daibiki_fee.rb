module Spree
  class CheckoutController < Spree::StoreController
    module AddDaibikiFee
      def self.prepended(base)
        base.before_action :apply_daibiki_fee
      end

      private

      def apply_daibiki_fee
        return unless params[:state] == 'payment' && params[:order]

        # Lazy but we're just going to assume that there's only one of these payment method types
        @daibiki = Spree::PaymentMethod::Daibiki.first
        @label = @daibiki.name
        @adjustable = current_order.shipments.first
        has_adjustment = @adjustable.adjustments.map(&:label).include?(@label)
        has_adjustment ? check_and_remove_daibiki_fee : add_daibiki_fee_adjustment
      end

      def check_and_remove_daibiki_fee
        # Remove the adjustment if it's already there, and the payment method has changed
        params[:order][:payments_attributes].each do |payment|
          next if payment[:payment_method_id] == @daibiki.id.to_s
          
          Rails.logger.info "Removing daibiki fee for order #{current_order.number}"
          adjustments = @adjustable.adjustments.where(label: @label)
          adjustments.destroy_all
        end
      end

      def add_daibiki_fee_adjustment
        # Add the adjustment if it's not there, and the payment method is daibiki
        params[:order][:payments_attributes].each do |payment|
          next if payment[:payment_method_id] != @daibiki.id.to_s

          Rails.logger.info "Adding daibiki shipping fee to order ##{current_order.number}"
          daibiki_fee_adjustment
        end
      end

      def daibiki_fee_adjustment
        # Only need to apply this fee once even if there were multiple packages
        @adjustable.adjustments.create!(
          amount: @daibiki.preferences[:daibiki_fee],
          label: @label,
          adjustable_type: "Spree::Order",
          adjustable_id: current_order.id,
          order_id: current_order.id,
          source_type: "Spree::PaymentMethod::Daibiki",
          source_id: @daibiki.id
        )
      end

      ::Spree::CheckoutController.prepend self
    end
  end
end
