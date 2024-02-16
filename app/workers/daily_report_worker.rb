# DailyReportWorker is responsible for generating daily reports.
class DailyReportWorker
  include Sidekiq::Worker

  def perform
    purchases = Purchase.where('purchase_date >= ? AND purchase_date < ?', 1.day.ago.beginning_of_day, Time.zone.now.beginning_of_day)
    report_data = process_purchases(purchases)
    admins = User.where(role: 'admin')

    purchases_summary = generate_purchases_summary(report_data)
    EmailService.send_daily_purchase_report_email(purchases_summary, admins)
  end

  private

  def process_purchases(purchases)
    report_data = purchases.map do |purchase|
      {
        id: purchase.id,
        customer_id: purchase.customer_id,
        product_id: purchase.product_id,
        quantity: purchase.quantity,
        total_price: purchase.total_price
      }
    end
    report_data
  end

  def generate_purchases_summary(report_data)
    summary = ''
    report_data.each do |purchase|
      summary += "------------------------------\n"
      summary += "Purchase ID: #{purchase[:id]}\n"
      summary += "Customer ID: #{purchase[:customer_id]}\n"
      summary += "Product ID: #{purchase[:product_id]}\n"
      summary += "Quantity: #{purchase[:quantity]}\n"
      summary += "Total Price: #{purchase[:total_price]}\n"
    end
    summary
  end
end
