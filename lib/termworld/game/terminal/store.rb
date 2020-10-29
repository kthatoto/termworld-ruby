module Termworld
  module Terminal
    class Store
      attr_reader :user, :users, :enemies, :logs

      def initialize(user)
        @user = user
        @logs = []
      end

      def update
        @users = Models::User.all_local
          .reject {|user| user.name == @user.name}
          .select {|user| user.current_map_name == @user.current_map_name}

        @enemies = Models::Enemy.all_local
          .select {|enemy| enemy.current_map_name == @user.current_map_name}

        if @user.attacking
          target = @enemies.find {|e| touched(@user, e)}
          attack(target) if target
          @user.attacking = false
        end

        @enemies.select(&:attacking).each do |enemy|
          enemy.attacking = false
          enemy.save_local
          target = [@user, @users].flatten.find {|u| touched(enemy, u)}
          enemy_attack(enemy, target, target.id == @user.id) if target
        end
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

      private

        def touched(object1, object2)
          (object1.positionx - object2.positionx).abs + (object1.positiony - object2.positiony).abs <= 1
        end

        def attack(target)
          atk = @user.attack_power
          damage = [(atk - target.defensive_power + (-(atk / 4)..(atk / 4)).to_a.sample), 0].max
          target.hp = [target.hp - damage, 0].max
          @logs.push Log.new({ type: :attack, message: "#{@user.name} attack #{target.name} #{damage} damges" })
          if target.hp <= 0
            @enemies = @enemies.reject {|e| e.id == target.id}
            @logs.push Log.new({ type: :defeat, message: "#{@user.name} defeat #{target.name}" })
            target.defeated
            res = @user.earn_exp(target.exp)
            if res[:leveluped]
              @logs.push Log.new({ type: :levelup, message: "#{@user.name} #{res[:diff][:level]} levelup" })
              @logs.push Log.new({ type: :levelup, message: "#{@user.name} HP #{res[:diff][:max_hp]} UP" })
              @logs.push Log.new({ type: :levelup, message: "#{@user.name} ATK #{res[:diff][:attack_power]} UP" })
              @logs.push Log.new({ type: :levelup, message: "#{@user.name} DEF #{res[:diff][:defensive_power]} UP" })
            end
          else
            target.save_local
          end
        end

        def enemy_attack(enemy, target)
          atk = enemy.attack_power
          damage = [(atk - target.defensive_power + (-(atk / 4)..(atk / 4)).to_a.sample), 0].max
          target.hp = [target.hp - damage, 0].max
          @logs.push Log.new({ type: :defend, message: "#{enemy.name} attack #{target.name} #{damage} damges" })
          if target.hp <= 0
            @logs.push Log.new({ type: :defeated, message: "#{target.name} defeated" })
          else
            target.save_local
          end
        end
    end
  end
end
