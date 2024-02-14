# Sends reports to administrators.
class ReportMailer < ActionMailer::Base
  default from: ENV['DEFAULT_EMAIL_FROM']

  def report_notification(subject, admins_mails, purchases_summary)
    @purchases_summary = purchases_summary

    mail(to: admins_mails, subject: subject)
  end
end
