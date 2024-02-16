module Api
  module V1
    # StatisticsController handles statistics for admins.
    class StatisticsController < ApplicationController
      before_filter :authenticate_user!
      before_filter -> { require_admin_role }
      before_filter :set_params, only: [:purchases_by_params, :purchase_count_by_granularity]

      def most_purchased_by_category
        @most_purchased_by_category ||= cached_most_purchased_by_category
        render json: @most_purchased_by_category, status: :ok
      end

      def top_revenue_by_category
        @top_revenue_by_category ||= cached_top_revenue_by_category
        render json: @top_revenue_by_category, status: :ok
      end

      def purchases
        options = extract_options
        if valid_params?(options)
          render json: StatisticsService.purchase_list_by_parameters(options), status: :ok
        else
          render json: { error: 'invalid parameters' }, status: :unprocessable_entity
        end
      end

      def purchases_by_granularity
        granularity = params[:granularity]
        options = extract_options

        if valid_params?(options) && valid_granularity?(granularity)
          render json: StatisticsService.purchases_by_granularity(granularity, options), status: :ok
        else
          render json: { error: 'invalid parameters' }, status: :unprocessable_entity
        end
      end

      private

      def valid_params?(options)
        only_one_id_present?(options[:user_id], options[:admin_id]) && admin_user?(options[:admin_id])
      end

      def only_one_id_present?(user_id, admin_id)
        (user_id.present? && admin_id.blank?) || (admin_id.present? && user_id.blank?) || (user_id.blank? && admin_id.blank?)
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
          user_id: params[:user_id],
          admin_id: params[:admin_id]
        }
      end

      def valid_granularity?(granularity)
        %w(hour day week year).include?(granularity)
      end

      # Cache methods

      def cached_most_purchased_by_category
        Rails.cache.fetch('most_purchased_by_category', expires_in: 1.hour) do
          StatisticsService.most_purchased_by_category
        end
      end

      def cached_top_revenue_by_category
        Rails.cache.fetch('top_revenue_by_category', expires_in: 1.hour) do
          StatisticsService.top_revenue_by_category
        end
      end
    end
  end
end
