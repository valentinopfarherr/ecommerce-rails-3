
# EmailService handles emails sending
class EmailService
  def self.send_admin_first_purchase_email(product, admin_creator, cc_admins)
    subject = "First purchase of #{product.name}"

    mail = PurchaseMailer.purchase_notification(subject, admin_creator.email, cc_admins.map(&:email), product)

    mail.deliver
  end

  def self.send_daily_purchase_report_email(purchases_summary, admins)
    mail = ReportMailer.report_notification('Daily purchasing report', admins.map(&:email), purchases_summary)

    mail.deliver
  end
end
