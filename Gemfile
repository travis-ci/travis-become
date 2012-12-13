require 'open-uri'
source :rubygems

def self.gem(*)
  super
rescue Bundler::DslError => e
  raise(e) unless e.message =~ /You cannot specify the same gem twice/i
end

instance_eval open("https://raw.github.com/travis-ci/travis-api/master/Gemfile").read
instance_eval open("https://raw.github.com/travis-ci/travis-sso/master/Gemfile").read
gem 'travis-api', github: "travis-ci/travis-api"
gem 'travis-sso', github: "travis-ci/travis-sso"
