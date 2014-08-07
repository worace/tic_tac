# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "tic_tac"
  s.version     = 1.0
  s.authors     = ["Horace Williams"]
  s.email       = ["horace.d.williams@gmail.com"]
  s.homepage    = "https://github.com/worace/tic-tac-toe"
  s.summary     = %q{Simple CLI tic-tac-toe game}
  s.description = %q{built as a sample for hacker school nyc <3}


  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rake'
end

