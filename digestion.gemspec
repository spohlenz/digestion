Gem::Specification.new do |s|
  s.name = "digestion"
  s.version = "1.2.2"
  s.summary = "Fine-grained digest controls for the Rails 3.1 asset pipeline."
  s.description = "Adds asset digest configuration options to Rails so that specific paths can be excluded from fingerprinting."
  s.files = Dir["README.md", "LICENSE", "lib/**/*"]
  s.authors = ["Sam Pohlenz"]
  s.email = "sam@sampohlenz.com"
  
  s.add_dependency "actionpack", ">= 3.1.0", "< 3.3"
end
