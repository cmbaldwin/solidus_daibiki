# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Spree::PaymentMethod::Daibiki, type: :model do
  let(:order) { Spree::Order.new }
  let(:payment_method) { described_class.create!(name: 'Daibiki', active: true) }
  let(:payment) do
    Spree::Payment.new(amount: 0.0, order:, payment_method:)
  end

  before do
    payment_method.save!
  end

  describe 'preferences' do
    before do
      payment_method.update!(
        preferred_daibiki_fee: '220',
        preferred_daibiki_fee_big: '330',
        preferred_dabiki_over_amount: '10000'
      )
    end

    it 'saves the preferences' do
      aggregate_failures do
        expect(payment_method.preferred_dabiki_fee).to eq('220')
        expect(payment_method.preferred_dabiki_fee_big).to eq('330')
        expect(payment_method.preferred_dabiki_over_amount).to eq('10000')
      end
    end
  end

  describe '#actions' do
    it 'returns actions' do
      expect(payment_method.actions).to eq(%w[capture void credit])
    end
  end

  describe '#can_capture?' do
    context 'when payment state is checkout' do
      before do
        payment.update!(state: 'checkout')
      end

      it 'returns true' do
        expect(payment_method.can_capture?(payment)).to be true
      end
    end

    context 'when payment state is pending' do
      before do
        payment.update!(state: 'pending')
      end

      it 'returns true' do
        expect(payment_method.can_capture?(payment)).to be true
      end
    end

    context 'when payment state is not pending or checkout' do
      before do
        payment.update!(state: 'void')
      end

      it 'returns false' do
        expect(payment_method.can_capture?(payment)).to be false
      end
    end
  end

  describe '#can_void?' do
    context 'when payment state is not void' do
      before do
        payment.update!(state: 'pending')
      end

      it 'returns true' do
        expect(payment_method.can_void?(payment)).to be true
      end
    end

    context 'when payment state is void' do
      before do
        payment.update!(state: 'void')
      end

      it 'returns false' do
        expect(payment_method.can_void?(payment)).to be false
      end
    end
  end

  describe '#capture' do
    it 'creates a new active merchant billing response' do
      allow(ActiveMerchant::Billing::Response).to receive(:new)
      payment_method.capture
      expect(ActiveMerchant::Billing::Response).to have_received(:new).with(true, '', {}, {})
    end

    it 'returns active merchant billing response' do
      expect(payment_method.capture).to be_a(ActiveMerchant::Billing::Response)
    end
  end

  describe '#void' do
    it 'creates a new active merchant billing response' do
      allow(ActiveMerchant::Billing::Response).to receive(:new)
      payment_method.void
      expect(ActiveMerchant::Billing::Response).to have_received(:new).with(true, '', {}, {})
    end

    it 'returns active merchant billing response' do
      expect(payment_method.void).to be_a(ActiveMerchant::Billing::Response)
    end
  end

  describe '#try_void' do
    it 'creates a new active merchant billing response' do
      allow(ActiveMerchant::Billing::Response).to receive(:new)
      payment_method.try_void
      expect(ActiveMerchant::Billing::Response).to have_received(:new).with(true, '', {}, {})
    end

    it 'returns active merchant billing response' do
      expect(payment_method.try_void).to be_a(ActiveMerchant::Billing::Response)
    end
  end

  describe '#credit' do
    it 'creates a new active merchant billing response' do
      allow(ActiveMerchant::Billing::Response).to receive(:new)
      payment_method.credit
      expect(ActiveMerchant::Billing::Response).to have_received(:new).with(true, '', {}, {})
    end

    it 'returns active merchant billing response' do
      expect(payment_method.credit).to be_a(ActiveMerchant::Billing::Response)
    end
  end

  describe '#source_required?' do
    it 'returns false' do
      expect(payment_method.source_required?).to be false
    end
  end
end
