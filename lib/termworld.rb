require "thor"
require "sequel"

Dir.glob("lib/**/*.rb")
  .map { |file| file.gsub(/^lib\//, '').gsub(/\.rb$/, '') }
  .reject { |file| file == 'termworld' }
  .each { |file| require file }
module Termworld
  def self.start
    DB.new
    CLI.start
  end
end
