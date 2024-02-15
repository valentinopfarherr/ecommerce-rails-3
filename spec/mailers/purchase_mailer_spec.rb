require 'rails_helper'

RSpec.describe PurchaseMailer, type: :mailer do
  describe '#purchase_notification' do
    let(:product) { create(:product) }
    let(:admin) { create(:admin) }
    let(:cc_admins) { create_list(:admin, 2) }
    let(:mail) { PurchaseMailer.purchase_notification('Subject', admin.email, cc_admins.map(&:email), product) }

    it 'renders the headers' do
      expect(mail.subject).to eq('Subject')
      expect(mail.to).to eq([admin.email])
      expect(mail.cc).to match_array(cc_admins.map(&:email))
      expect(mail.from).to eq([ENV['DEFAULT_EMAIL_FROM']])
    end
  end
end
