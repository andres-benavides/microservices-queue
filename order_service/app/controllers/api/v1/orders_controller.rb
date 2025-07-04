module Api
  module V1
    class OrdersController < ApplicationController
      def index
        orders = Orders::FetchService.call(params[:customer_id])
        render json: orders
      end
      
      def create
        order = Orders::CreateService.call(order_params)
        render json: order, status: :created
      rescue ActiveRecord::RecordInvalid => e
        render json: { error: e.record.errors.full_messages }, status: :unprocessable_entity
      rescue => e
        Rails.logger.error("Error creating order: #{e.message}")
        render json: { error: e.message }, status: :unprocessable_entity
      end

      private

      def order_params
        params.require(:order).permit(
          :customer_id,
          :product_name,
          :quantity,
          :price,
          :status
        )
      end
    end
  end
end
