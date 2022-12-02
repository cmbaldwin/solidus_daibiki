# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Checkout - Payment with Daibiki', type: :feature, js: true do
  let(:payment_method) do
    create(:daibiki_payment_method,
           daibiki_fee: '220',
           daibiki_fee_big: '330',
           daibiki_over_amount: '10000')
  end

  let(:user) { create(:user_with_addresses) }
  let(:order) { create(:order_with_line_items) }

  before do
    payment_method
    order.associate_user!(user)

    allow_any_instance_of(Spree::CheckoutController).to receive_messages(current_order: order)
    allow_any_instance_of(Spree::CheckoutController).to receive_messages(try_spree_current_user: user)
    allow_any_instance_of(Spree::OrdersController).to receive_messages(try_spree_current_user: user)
    visit spree.checkout_state_path(:payment)
  end

  it 'shows the daibiki payment' do
    expect(page).to have_content('220')
    expect(page).to have_content('330')
  end
end
