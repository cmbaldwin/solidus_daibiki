# frozen_string_literal: true

FactoryBot.define do
  # Define your Spree extensions Factories within this file to enable applications, and other extensions to use and override them.
  #
  # Example adding this to your spec_helper will load these Factories for use:
  # require 'solidus_bank_transfer/factories'

  factory :bank_transfer_payment_method, class: Spree::PaymentMethod::Daibiki do
    name { 'Daibiki' }
    preferred_daibiki_fee { '123' }
  end
end
