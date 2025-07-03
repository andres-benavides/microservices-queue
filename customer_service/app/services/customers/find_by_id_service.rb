module Customers
  class FindByIdService
    def self.call(id)
      ::Customer.find_by(id: id)
    end
  end
end
