guard :rspec, all_after_pass: true, all_on_start: true, cmd: "bundle exec rspec", failed_mode: :focus do
  watch(%r{^spec/(.+)_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$}) { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^lib/foobara/(.+)\.rb$}) { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^lib/foobara/util/(.+)\.rb$}) { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^spec/spec_helper.rb$}) { "spec/" }
end
