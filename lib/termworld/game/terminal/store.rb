module Termworld
  module Terminal
    class Store
      attr_reader :user, :users, :map

      def initialize(user)
        @user = user
        @map = Resources::Maps::Town.new
      end

      def update
        @users = Models::User.all_local.reject {|user| user.name == @user.name}
      end
    end
  end
end
