module Termworld
  module Terminal
    class Store
      attr_reader :user, :users, :enemies

      def initialize(user)
        @user = user
      end

      def update
        @users = Models::User.all_local
          .reject {|user| user.name == @user.name}
          .select {|user| user.current_map_name == @user.current_map_name}

        @enemies = Models::Enemy.all_local
          .select {|enemy| enemy.current_map_name == @user.current_map_name}
      end

      def map
        user.current_map
      end

      def user_hp_percentage
        user.hp.to_f / user.max_hp
      end

      def user_hp_text
        "#{user.hp} / #{user.max_hp}"
      end

      def user_hp_color
        if user_hp_percentage > 0.3
          "GREEN"
        elsif user_hp_percentage > 0.1
          "YELLOW"
        else
          "RED"
        end
      end

      def user_exp_percentage
        user.exp.to_f / user.next_level_exp
      end

      def user_exp_text
        "#{user.exp} / #{user.next_level_exp}"
      end
    end
  end
end
