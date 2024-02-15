RSpec.describe EmailService do
  describe '.send_admin_first_purchase_email' do
    let(:product) { create(:product) }
    let(:admin_creator) { create(:admin) }
    let(:cc_admins) { create_list(:admin, 2) }

    it 'sends an email to the admin creator and cc admins' do
      expect(PurchaseMailer).to receive(:purchase_notification)
        .with("First purchase of #{product.name}", admin_creator.email, cc_admins.map(&:email), product)
        .and_return(double(deliver: true))

      EmailService.send_admin_first_purchase_email(product, admin_creator, cc_admins)
    end
  end

  describe '.send_daily_purchase_report_email' do
    let(:purchases_summary) { 'Summary of purchases' }
    let(:admin1) { create(:admin) }
    let(:admin2) { create(:admin) }
    let(:admins) { [admin1, admin2] }

    it 'sends a daily purchase report email to admins' do
      expect(ReportMailer).to receive(:report_notification)
        .with('Daily purchasing report', admins.map(&:email), purchases_summary)
        .and_return(double(deliver: true))

      EmailService.send_daily_purchase_report_email(purchases_summary, admins)
    end
  end
end
