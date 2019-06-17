lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "constants/version"

Gem::Specification.new do |spec|
  spec.name          = "termworld"
  spec.version       = Termworld::VERSION
  spec.authors       = ["kthatoto"]
  spec.email         = ["kthatoto@gmail.com"]

  spec.summary       = %q{Programmable RPG Games.}
  spec.description   = %q{Programmable RPG Games that can be played on the terminal and with any programming languages.}
  spec.homepage      = "https://github.com/kthatoto/termworld"
  spec.license       = "MIT"

  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "thor"
  spec.add_dependency "sequel"
  spec.add_dependency "sqlite3"

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pry-byebug"
end
