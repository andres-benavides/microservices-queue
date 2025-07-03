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
    end
  end
end

