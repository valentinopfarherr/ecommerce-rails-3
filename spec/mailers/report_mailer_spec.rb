require 'rails_helper'

RSpec.describe ReportMailer, type: :mailer do
  describe '#report_notification' do
    let(:subject) { 'Daily purchasing report' }
    let(:admins_mails) { ['admin1@example.com', 'admin2@example.com'] }
    let(:purchases_summary) { 'Purchase ID: 1\nCustomer ID: 1\nProduct ID: 1\nQuantity: 3\nTotal Price: 150.0\n------------------------------\n' }

    let(:mail) { described_class.report_notification(subject, admins_mails, purchases_summary) }

    it 'renders the headers' do
      expect(mail.subject).to eq(subject)
      expect(mail.to).to eq(admins_mails)
      expect(mail.from).to eq([ENV['DEFAULT_EMAIL_FROM']])
    end
  end
end
