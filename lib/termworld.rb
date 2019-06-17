require "thor"
require "termworld/cli"
require "termworld/constants/version"
Dir.glob("lib/**/*.rb").map { |file|
  file.gsub(/^lib\//, '').gsub(/\.rb$/, '')
}.reject { |file|
  file == 'termworld'
}.each { |file|
  require file
}
module Termworld
  def self.start
    Termworld::CLI.start
  end
end
