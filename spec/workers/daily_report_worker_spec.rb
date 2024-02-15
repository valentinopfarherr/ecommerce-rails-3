require 'rails_helper'

RSpec.describe DailyReportWorker, type: :worker do
  describe '#perform' do
    let!(:admin) { create(:admin) }
    let!(:purchase) { create(:purchase) }

    it 'sends daily purchase report email to administrators' do
      expect(EmailService).to receive(:send_daily_purchase_report_email).with(any_args)
      described_class.new.perform
    end
  end
end
