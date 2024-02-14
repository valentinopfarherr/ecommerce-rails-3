module Api
  module V1
    # StatisticsService provides statistical analysis functionalities through SQL queries.
    class StatisticsService
      def self.most_purchased_by_category
        query = <<-SQL
          SELECT pc.category_id, p.id AS product_id, p.name AS product_name, SUM(pu.quantity) AS total_purchases
          FROM purchases pu
          INNER JOIN products p ON pu.product_id = p.id
          INNER JOIN product_categories pc ON p.id = pc.product_id
          GROUP BY pc.category_id, p.id, p.name
          HAVING SUM(pu.quantity) = (
            SELECT MAX(purchase_count)
            FROM (
              SELECT SUM(pu.quantity) AS purchase_count
              FROM purchases pu
              INNER JOIN products prod ON pu.product_id = prod.id
              INNER JOIN product_categories cat ON prod.id = cat.product_id
              WHERE cat.category_id = pc.category_id
              GROUP BY prod.id
            ) AS category_purchases
          )
          ORDER BY pc.category_id;
        SQL

        results = ActiveRecord::Base.connection.execute(query)

        products_by_category = {}

        results.each do |row|
          category_id = row['category_id']
          product_id = row['product_id']
          product_name = row['product_name']
          total_purchases = row['total_purchases']

          products_by_category[category_id] = { id: product_id, name: product_name, total_purchases: total_purchases }
        end

        products_by_category
      end

      def self.top_revenue_by_category
        query = <<-SQL
          SELECT pc.category_id,
                 p.id AS product_id,
                 p.name AS product_name,
                 ROUND(SUM(p.price * pu.quantity), 2) AS total_revenue
          FROM purchases pu
          INNER JOIN products p ON pu.product_id = p.id
          INNER JOIN product_categories pc ON p.id = pc.product_id
          GROUP BY pc.category_id, p.id, p.name
          ORDER BY pc.category_id, total_revenue DESC;
        SQL

        results = ActiveRecord::Base.connection.execute(query)

        top_products_by_category = {}

        results.each do |row|
          category_id = row['category_id']
          product_id = row['product_id']
          product_name = row['product_name']
          total_revenue = row['total_revenue']

          top_products_by_category[category_id] ||= []
          if top_products_by_category[category_id].length < 3
            top_products_by_category[category_id] << { id: product_id, name: product_name, total_revenue: total_revenue }
          end
        end

        top_products_by_category
      end

      def self.purchase_list_by_parameters(options = {})
        purchases = Purchase.scoped

        purchases = purchases.where('purchase_date >= ?', options[:start_date]) if options[:start_date].present?
        purchases = purchases.where('purchase_date <= ?', options[:end_date]) if options[:end_date].present?
        purchases = purchases.joins(product: :product_categories).where('product_categories.category_id = ?', options[:category_id]) if options[:category_id].present?
        purchases = purchases.where(customer_id: options[:buyer_id]) if options[:buyer_id].present?
        purchases = purchases.where(customer_id: options[:admin_id]) if options[:admin_id].present?

        purchases.map do |purchase|
          {
            purchase_id: purchase.id,
            product_id: purchase.product_id,
            customer_id: purchase.customer_id,
            purchase_date: purchase.purchase_date,
            quantity: purchase.quantity
          }
        end
      end

      def self.purchases_by_granularity(granularity, options = {})
        purchases = Purchase.scoped

        purchases = purchases.where('purchase_date >= ?', options[:start_date]) if options[:start_date].present?
        purchases = purchases.where('purchase_date <= ?', options[:end_date]) if options[:end_date].present?
        purchases = purchases.joins(product: :product_categories).where('product_categories.category_id = ?', options[:category_id]) if options[:category_id].present?
        purchases = purchases.where(customer_id: options[:buyer_id]) if options[:buyer_id].present?
        purchases = purchases.where(customer_id: options[:admin_id]) if options[:admin_id].present?

        granularity = granularity.to_sym if granularity.present?

        case granularity
        when :hour
          result = purchases.group("DATE_TRUNC('hour', purchase_date)").count
          format_result_by_hour(result)
        when :day
          result = purchases.group("DATE_TRUNC('day', purchase_date)").count
          format_result_by_day(result)
        when :week
          result = purchases.group("DATE_TRUNC('week', purchase_date)").count
          format_result_by_week(result)
        when :year
          result = purchases.group("DATE_TRUNC('year', purchase_date)").count
          format_result_by_year(result)
        else
          result = purchases.group("DATE_TRUNC('day', purchase_date)").count # Por defecto, agrupar por día
          format_result_by_day(result)
        end
      end

      private

      def self.format_result_by_hour(result)
        formatted_result = {}
        result.each { |date, count| formatted_result[Time.parse(date).strftime('%Y-%m-%d %H:%M')] = count }
        formatted_result
      end

      def self.format_result_by_day(result)
        formatted_result = {}
        result.each { |date, count| formatted_result[Time.parse(date).strftime('%Y-%m-%d')] = count }
        formatted_result
      end

      def self.format_result_by_week(result)
        formatted_result = {}
        result.each { |date, count| formatted_result[Time.parse(date).strftime('%Y-%m-%d')] = count }
        formatted_result
      end

      def self.format_result_by_year(result)
        formatted_result = {}
        result.each { |date, count| formatted_result[Time.parse(date).strftime('%Y')] = count }
        formatted_result
      end
    end
  end
end
