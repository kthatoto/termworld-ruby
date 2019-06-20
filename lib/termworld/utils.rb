module Termworld
  class ColorUtil
    class << self
      def reden(str)
        "\e[31m#{str}\e[0m"
      end
      def greenen(str)
        "\e[32m#{str}\e[0m"
      end
      def yellowen(str)
        "\e[33m#{str}\e[0m"
      end
      def bluen(str)
        "\e[34m#{str}\e[0m"
      end
    end
  end
end
