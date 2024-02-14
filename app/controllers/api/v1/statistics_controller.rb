module Api
  module V1
    # StatisticsController handles statistics for admins.
    class StatisticsController < ApplicationController
      before_filter :authenticate_user!
      before_filter -> { require_role('admin') }
      before_filter :set_params, only: [:purchases_by_params, :purchase_count_by_granularity]

      def most_purchased_by_category
        render json: StatisticsService.most_purchased_by_category, status: :ok
      end

      def top_revenue_by_category
        render json: StatisticsService.top_revenue_by_category, status: :ok
      end

      def purchases
        options = extract_options

        validate_and_render(options) do
          StatisticsService.purchase_list_by_parameters(options)
        end
      end

      def purchases_by_granularity
        granularity = params[:granularity]
        options = extract_options

        if valid_granularity?(granularity)
          validate_and_render(options) do
            StatisticsService.purchases_by_granularity(granularity, options)
          end
        else
          render json: { error: 'invalid granularity' }, status: :unprocessable_entity
        end
      end

      private

      def only_one_id_present?(buyer_id, admin_id)
        (buyer_id.present? && admin_id.blank?) || (admin_id.present? && buyer_id.blank?) || (buyer_id.blank? && admin_id.blank?)
      end

      def admin_user?(admin_id)
        return true unless admin_id.present?
        user = User.find_by_id(admin_id)
        user.present? && user.admin?
      end

      def extract_options
        {
          start_date: params[:start_date],
          end_date: params[:end_date],
          category_id: params[:category_id],
          buyer_id: params[:buyer_id],
          admin_id: params[:admin_id]
        }
      end

      def valid_granularity?(granularity)
        %w(hour day week year).include?(granularity)
      end

      def validate_and_render(options)
        if only_one_id_present?(options[:buyer_id], options[:admin_id]) && admin_user?(options[:admin_id])
          render json: yield, status: :ok
        else
          render json: { error: 'invalid parameters' }, status: :unprocessable_entity
        end
      end
    end
  end
end
