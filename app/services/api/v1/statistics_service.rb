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
        conditions = []

        conditions << "pu.purchase_date >= #{options[:start_date]}" if options[:start_date].present?

        conditions << "pu.purchase_date <= #{options[:end_date]}" if options[:end_date].present?

        conditions << "pu.product_id IN (SELECT product_id FROM product_categories WHERE category_id = #{options[:category_id]})" if options[:category_id].present?

        conditions << "pu.customer_id = #{options[:buyer_id]}" if options[:buyer_id].present?

        conditions << "pu.customer_id = #{options[:admin_id]}" if options[:admin_id].present?

        where_clause = conditions.empty? ? '' : "WHERE #{conditions.join(' AND ')}"

        query = <<-SQL
          SELECT pu.id AS purchase_id, pu.product_id, pu.customer_id, pu.purchase_date, pu.quantity
          FROM purchases pu
          #{where_clause}
        SQL

        results = ActiveRecord::Base.connection.execute(query)

        purchases_by_parameters = []

        results.each do |row|
          purchases_by_parameters << {
            purchase_id: row['purchase_id'],
            product_id: row['product_id'],
            customer_id: row['customer_id'],
            purchase_date: row['purchase_date'],
            quantity: row['quantity']
          }
        end

        purchases_by_parameters
      end

      def self.purchases_by_granularity(granularity, options = {})
        case granularity
        when 'hour'
          time_format = '%Y-%m-%d %H:00:00'
        when 'day', 'week'
          time_format = '%Y-%m-%d'
        when 'year'
          time_format = '%Y'
        else
          raise ArgumentError, 'Invalid granularity parameter'
        end

        query = <<-SQL
          SELECT DATE_FORMAT(purchase_date, :time_format) AS time_period, SUM(quantity) AS total_quantity
          FROM purchases
          WHERE purchase_date BETWEEN :start_date AND :end_date
            AND (:category_id IS NULL OR product_id IN (SELECT product_id FROM product_categories WHERE category_id = :category_id))
            AND (:buyer_id IS NULL OR customer_id = :buyer_id)
            AND (:admin_id IS NULL OR customer_id = :admin_id)
          GROUP BY time_period
        SQL

        results = ActiveRecord::Base.connection.execute(query, options)

        purchases_by_granularity = {}

        results.each do |row|
          purchases_by_granularity[row['time_period']] = row['total_quantity']
        end

        purchases_by_granularity
      end
    end
  end
end
