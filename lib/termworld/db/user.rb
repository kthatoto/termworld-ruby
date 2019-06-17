module Termworld
  class User
    def initialize
      $db.create_table :users do
        primary_key :id
        String :name
        Integer :price
      end
    end
  end
end
