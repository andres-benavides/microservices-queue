module Customers
  class CustomerClient
    BASE_URL = ENV['CUSTOMER_SERVICE_URL'] || 'http://customer_service:3000'

    def self.get_customer(customer_id)
      response = Faraday.get("#{BASE_URL}/api/v1/customers/#{customer_id}")
      return nil unless response.success?

      JSON.parse(response.body)
    rescue Faraday::Error => e
      Rails.logger.error("Error fetching customer #{customer_id}: #{e.message}")
      nil
    end
  end
end
