# -*- encoding: utf-8 -*-
# stub: toml-rb 0.3.8 ruby lib

Gem::Specification.new do |s|
  s.name = "toml-rb"
  s.version = "0.3.8"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Emiliano Mancuso", "Lucas Tolchinsky"]
  s.date = "2015-06-12"
  s.description = "A TOML parser using Citrus parsing library. "
  s.email = ["emiliano.mancuso@gmail.com", "lucas.tolchinsky@gmail.com"]
  s.homepage = "http://github.com/eMancu/toml-rb"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.4.8"
  s.summary = "TOML parser in ruby, for ruby."

  s.installed_by_version = "2.4.8" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<citrus>, ["> 3.0", "~> 3.0"])
    else
      s.add_dependency(%q<citrus>, ["> 3.0", "~> 3.0"])
    end
  else
    s.add_dependency(%q<citrus>, ["> 3.0", "~> 3.0"])
  end
end
