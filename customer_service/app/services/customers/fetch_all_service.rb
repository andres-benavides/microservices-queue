module Customers
  class FetchAllService
    def self.call
      ::Customer.all
    end
  end
end
