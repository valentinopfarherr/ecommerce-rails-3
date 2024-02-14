
# EmailService handles emails sending
class EmailService
  def self.send_admin_first_purchase_email(product, admin_creator, cc_admins)
    subject = "First purchase of #{product.name}"

    mail = PurchaseMailer.purchase_notification(subject, admin_creator.email, cc_admins.pluck(:email), product)

    mail.deliver
  end
end
