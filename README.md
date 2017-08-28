CapacityKeeper ![stability-wip](https://img.shields.io/badge/stability-work_in_progress-lightgrey.svg) [![Build Status](https://travis-ci.org/goldeneggg/capacity_keeper.svg?branch=master)](https://travis-ci.org/goldeneggg/capacity_keeper)
==========

__WIP__


## Overview

If this method call is system-unfriendly

```ruby
innocent_method(value)
```

↓ By using `capacity_keeper gem`, this may change to be system-friendly

```ruby
with_capacity(keeper: ExampleKeeper) do
  innocent_method(value)
end
```


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'capacity_keeper'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install capacity_keeper


## Simple Usage

Your plugin class must be inherit `Capacitykeeper::Plugin` class,
and override `satisfied?`, `reduce_capacity` and `gain_capacity` abstract methods.

Example of plugin implementation as follows

```ruby
# Capacitykeeper::Plugin must be inherited.
class TestCapacityKeeperPlugin < Capacitykeeper::Plugin

  # Define configs
  config :max, 10

  @@counter = 0

  # @override
  def satisfied?
    @@counter <= configs[:max]
  end

  # @override
  def reduce_capacity
    @@counter += 1
  end

  # @override
  def gain_capacity
    @@counter -= 1 if @@counter > 0
  end
end
```

If your process need to keep capacity, include `CapacityKeeper` module, and use `with_capacity` method

```ruby
require 'capacity_keeper'

class Example
  include CapacityKeeper

  def xxx
    with_capacity(keeper: TestCapacityKeeperPlugin) do
      some codes
    end
  end
end
```

### Exection sequence

1. Execute `satisfied?` of your plugin implementation for capacity satisfation check
1. If satisfied,
    1. Execute `reduce_capacity` of your plugin implementation hook
    1. Execute your assigned block
    1. Execute `gain_capacity` of your plugin implementation hook


## Use runtime options

If your plugin class want to refer `@opts` variable, please assign `opts` argument of `with_capacity` method calling.

```ruby
require 'capacity_keeper'

class Example
  include CapacityKeeper

  def xxx
    with_capacity(keeper: TestCapacityKeeperPlugin, opts: { hello: 'world' }) do
      some codes
    end
  end
end
```

`@opts` variable can be refered from your plugin class.

```ruby
class TestCapacityKeeperPlugin < Capacitykeeper::Plugin

  option :max, 10

  @@counter = 0

  # @override
  def satisfied?
    puts @opts.inspect  # @opts variable can be refered => { hello: 'world' }
    @@counter <= options[:max]
  end

  # @override
  def reduce_capacity
    @@counter += 1
  end

  # @override
  def gain_capacity
    @@counter -= 1 if @@counter > 0
  end
end
```


## Keep with multi keepers

You can use multi keepers by calling `add_capacity` method.

```ruby
with_capacity(keeper: KeeperA).add_keeper(keeper: KeeperB).add_keeper(keeper: KeeperC) do
  innocent_method(value)
end
```

### Exection sequence

1. Execute `satisfied?` of KeeperA for capacity satisfation check
1. Execute `satisfied?` of KeeperB for capacity satisfation check
1. Execute `satisfied?` of KeeperC for capacity satisfation check
1. If satisfied,
    1. Execute `reduce_capacity` of KeeperA hook
    1. Execute `reduce_capacity` of KeeperB hook
    1. Execute `reduce_capacity` of KeeperC hook
    1. Execute your assigned block
    1. Execute `gain_capacity` of KeeperA hook
    1. Execute `gain_capacity` of KeeperB hook
    1. Execute `gain_capacity` of KeeperC hook


## Configurations
Default keeper configuration on your app using `Capacitykeeper.configure`

```ruby
Capacitykeeper.configure do |config|
  config.retry_count = 5

  config.retry_sleep_second = 5

  config.raise_on_retry_fail = false

  config.verbose = ::Logger.new(STDOUT)

  config.verbose = false
end
```


## Development

Setup

```bash
$ git clone git@github.com:goldeneggg/capacity_keeper.git
$ bin/setup
```

Run tests

```bash
$ bundle exec rake spec
```

Debug using pry


```bash
$ bin/console
```

To release a new version, update the version number in `version.rb`.


## Contributing

Bug reports and pull requests are welcome on GitHub at [issues](https://github.com/goldeneggg/capacity_keeper/issues)


## Author

[goldeneggg](https://github.com/goldeneggg)
