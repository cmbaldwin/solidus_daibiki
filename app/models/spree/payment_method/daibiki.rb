# frozen_string_literal: true

module Spree
  class PaymentMethod::Daibiki < PaymentMethod
    preference :daibiki_fee, :integer, default: 220
    preference :daibiki_fee_big, :integer, default: 330
    preference :daibiki_over_amount, :integer, default: 10_000
    preference :daibiki_max_amount, :integer, default: 10_000
    preference :limit_to_registered_users, :boolean, default: true

    def actions
      %w[capture void credit]
    end

    # Indicates whether its possible to capture the payment
    def can_capture?(payment)
      %w[checkout pending].include?(payment.state)
    end

    # Indicates whether its possible to void the payment.
    def can_void?(payment)
      payment.state != 'void'
    end

    def capture(*)
      simulated_successful_billing_response
    end

    def void(*)
      simulated_successful_billing_response
    end
    alias try_void void

    def credit(*)
      simulated_successful_billing_response
    end

    def source_required?
      false
    end

    private

    def simulated_successful_billing_response
      ActiveMerchant::Billing::Response.new(true, '', {}, {})
    end
  end
end
