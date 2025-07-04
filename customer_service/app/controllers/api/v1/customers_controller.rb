module Api
  module V1
    class CustomersController < ApplicationController
      def index
        customers = Customers::FetchAllService.call
        render json: customers
      end

      def show
        customer = Customers::FindByIdService.call(params[:id])
        if customer
          render json: customer
        else
          render json: { error: "Customer not found" }, status: :not_found
        end
      end
      
      def create
        order = Customers::Create.call(customer_params)
        render json: order, status: :created
      rescue ActiveRecord::RecordInvalid => e
        render json: { error: e.record.errors.full_messages }, status: :unprocessable_entity
      rescue => e
        Rails.logger.error("Error creating order: #{e.message}")
        render json: { error: e.message }, status: :unprocessable_entity
      end

      private

      def customer_params
        params.require(:customer).permit(
          :id,
          :name,
          :address,
          :age
        )
      end

    end
  end
end

