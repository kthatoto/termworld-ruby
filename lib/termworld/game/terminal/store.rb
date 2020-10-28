module Termworld
  module Terminal
    class Store
      attr_reader :user, :users

      def initialize(user)
        @user = user
      end

      def update
        @users = Models::User.all_local
          .reject {|user| user.name == @user.name}
          .select {|user| user.current_map_name == @user.current_map_name}
      end

      def map
        user.current_map
      end
    end
  end
end
