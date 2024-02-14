# Sends purchase notifications to administrators and creator_email.
class PurchaseMailer < ActionMailer::Base
  default from: ENV['DEFAULT_EMAIL_FROM']

  def purchase_notification(subject, creator_email, cc_admin_emails, product)
    @product = product

    mail(to: creator_email, cc: cc_admin_emails, subject: subject)
  end
end
