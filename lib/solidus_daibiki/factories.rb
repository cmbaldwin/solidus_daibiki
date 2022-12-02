# frozen_string_literal: true

FactoryBot.define do
  # Define your Spree extensions Factories within this file to enable applications, and other extensions to use and override them.
  #
  # Example adding this to your spec_helper will load these Factories for use:
  # require 'solidus_daibiki/factories'

  factory :daibiki_payment_method, class: Spree::PaymentMethod::Daibiki do
    name { 'Daibiki' }
    preferred_daibiki_fee { '220' }
    preferred_daibiki_fee_big { '330' }
    preferred_daibiki_over_amount { '10000' }
  end
end
