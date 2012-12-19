task :Gemfile do
  require 'open-uri'
  content = ''
  content << open("https://raw.github.com/travis-ci/travis-api/master/Gemfile").read
  content << open("https://raw.github.com/travis-ci/travis-sso/master/Gemfile").read
  content << %[\ngem 'travis-api', github: "travis-ci/travis-api"]
  content << %[\ngem 'travis-sso', github: "travis-ci/travis-sso"]
  content.gsub!(/^gemspec/, '')
  seen = []
  content.gsub!(/^\s*gem '[^']+'.*$/) do |match|
    line, name = match.to_s, match[/'[^']+'/]
    line = '' if seen.include? name
    seen << name
    line
  end
  File.open('Gemfile', 'w') do |f|
    f << content
  end
end
