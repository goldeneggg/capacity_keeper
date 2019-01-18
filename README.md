CapacityKeeper ![stability-wip](https://img.shields.io/badge/stability-work_in_progress-lightgrey.svg) [![Build Status](https://travis-ci.org/goldeneggg/capacity_keeper.svg?branch=master)](https://travis-ci.org/goldeneggg/capacity_keeper)
==========

__WIP__


## Overview

If this method call is system-unfriendly

```ruby
innocent_method
```

↓ By using `capacity_keeper` gem, this may change to be system-friendly

```ruby
within_capacity(keeper: TestKeeper) do
  innocent_method
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

First, you need to implement keeper class of capacity_keeper.
Your keeper class must be inherited `CapacityKeeper::Keeper` class,
and override `performable?`, `begin_process` and `finish_process` abstract methods.

Example of keeper implementation as follows

```ruby
# CapacityKeeper::Keeper must be inherited.
class TestKeeper < CapacityKeeper::Keeper

  # Define class original configs
  config :max, 10

  @@counter = 0

  # @override
  def performable?
    # check current counter is not over max value
    @@counter <= configs[:max]
  end

  private

  # @override
  def begin_process
    # enqueue counter
    @@counter += 1
  end

  # @override
  def finish_process
    # dequeue counter
    @@counter -= 1 if @@counter > 0
  end
end
```

If your process need to keep capacity, include `CapacityKeeper` module, and use `within_capacity` method

```ruby
require 'capacity_keeper'

class Example
  # must be included CapacityKeeper module
  include CapacityKeeper

  def xxx
    # enclose with within_capacity method, and assign keeper class for keeping capacity
    within_capacity(keeper: TestKeeper) do
      # some system-unfriendly method
      innocent_method
    end
  end
end
```

### Exection sequence

1. Execute `performable?` of your keeper implementation for capacity satisfation check
1. If performable,
    1. Execute `before` of your keeper implementation
    1. __Execute your assigned block__
    1. Execute `after` of your keeper implementation


## Use dynamic runtime options

If your keeper class want to refer `@opts` variable, please assign `opts` argument of `within_capacity` method calling.

```ruby
require 'capacity_keeper'

class Example
  include CapacityKeeper

  def xxx
    within_capacity(keeper: TestKeeper, opts: { hello: 'world' }) do
      innocent_method
    end
  end
end
```

`@opts` variable can be refered from your keeper class.

```ruby
class TestKeeper < CapacityKeeper::Keeper

  config :max, 10

  @@counter = 0

  # @override
  def performable?
    puts @opts.inspect  # @opts variable can be refered => { hello: 'world' }
    @@counter <= configs[:max]
  end

  private

  # @override
  def begin_process
    @@counter += 1
  end

  # @override
  def finish_process
    @@counter -= 1 if @@counter > 0
  end
end
```


## Capacity keeping with multi keepers

You can assign multi keepers by calling `add_keeper` method.

```ruby
within_capacity(keeper: KeeperA).add_keeper(KeeperB).add_keeper(KeeperC) do
  # applied KeeperA and KeeperB and KeeperC
  innocent_method
end
```

### Exection sequence

1. Execute `performable?` of KeeperA for capacity satisfation check
1. Execute `performable?` of KeeperB for capacity satisfation check
1. Execute `performable?` of KeeperC for capacity satisfation check
1. If performable on all keeperList,
    1. Execute `before` of KeeperA
    1. Execute `before` of KeeperB
    1. Execute `before` of KeeperC
    1. __Execute your assigned block__
    1. Execute `after` of KeeperA
    1. Execute `after` of KeeperB
    1. Execute `after` of KeeperC

### Add some keepers under specific conditions

if you want to add some keepers under specific conditions, you can use `CapacityKeeper::KeeperList#perform` method.

```ruby
str = 'C'

keeper_list = within_capacity(keeper: KeeperA)

if str == 'B'
  keeper_list.add_keeper(KeeperB)
end

if str == 'C'
  keeper_list.add_keeper(KeeperC)
end

keeper_list.perform do
  # applied KeeperA and KeeperC
  innocent_method
end
```


## Configurations
Default keeper configuration on your app using `CapacityKeeper.configure`

```ruby
CapacityKeeper.configure do |config|
  config.retry_count = 5

  config.retry_interval_second = 5

  config.raise_on_retry_fail = false

  config.logger = ::Logger.new(STDOUT)

  config.verbose = false
end
```

Override class original configs

```ruby
class TestKeeper < CapacityKeeper::Keeper

  # Override default configs by class original values
  retry_count 10
  retry_interval_second 10
  raise_on_retry_fail true
  logger TestLogger.new
  verbose true

:
:
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

Generate new CHANGELOG.md


```bash
$ bin/changelog
```

## Contributing

Bug reports and pull requests are welcome on GitHub at [issues](https://github.com/goldeneggg/capacity_keeper/issues)


## Author

[goldeneggg](https://github.com/goldeneggg)
