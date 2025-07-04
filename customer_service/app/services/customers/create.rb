module Customers
  class Create
     def self.call(params)
      ::Customer.create!(params)
    end
  end
end