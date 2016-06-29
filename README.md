This is an inspection tool allowing you to log in as a different user on [travis-web](https://github.com/travis-ci/travis-web).

## Local dev

### Config

    $ heroku config:get travis_config -a travis-become-production > config/travis.yml
    # nest all of the config under a `development` key -- since it indexes by env

### Run

    $ bundle exec script/server
