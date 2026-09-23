Dir["#{__dir__}/../**/*.rb"].each do |file|
  # only load this via require "foobara/util/object_space" for detecting memory leaks.
  unless file =~ /\butil\/object_space.rb$/
    require file
  end
end
