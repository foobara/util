require_relative "lib/foobara/util/version"

Gem::Specification.new do |spec|
  spec.name = "foobara-util"
  spec.version = Foobara::Util::VERSION
  spec.authors = ["Miles Georgi"]
  spec.email = ["azimux@gmail.com"]

  spec.summary = "Utility functions used across various Foobara projects"
  spec.homepage = "https://github.com/foobara/util"

  # Equivalent to SPDX License Expression: MIT OR Apache-2.0 OR MPL-2.0
  spec.license = "Foobara Delayed Choice License"
  spec.licenses = ["MIT", "Apache-2.0", "MPL-2.0"]

  spec.required_ruby_version = ">= #{File.read("#{__dir__}/.ruby-version")}"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/main/CHANGELOG.md"

  spec.files = Dir[
    "lib/**/*",
    "LICENSE.txt"
  ]

  spec.require_paths = ["lib"]
  spec.metadata["rubygems_mfa_required"] = "true"
end
