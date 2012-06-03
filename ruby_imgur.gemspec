# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "ruby_imgur"
  s.version = "0.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Fraser Murray"]
  s.date = "2012-05-23"
  s.email = "fraser.m.murray@gmail.com"
  s.files = ["lib/imgur.rb", "lib/test", "lib/imgur_rails.rb"]
  s.homepage = ""
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.15"
  s.summary = "library for imgur api"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
