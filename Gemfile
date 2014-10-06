source "http://rubygems.org"

# Specify your gem's dependencies in rspec-approvals.gemspec
gemspec

gem 'rubysl', '~> 2.0', :platform => :rbx
gem 'rake'
group :development do
  if RUBY_VERSION < '1.9.3'
    gem 'ruby-debug'
  else
    gem 'debugger'
  end
end
