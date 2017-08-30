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
within_capacity(plugin: TestPlugin) do
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

First, you need to implement plugin class of capacity_keeper.
Your plugin class must be inherit `CapacityKeeper::Plugin` class,
and override `reservable?`, `deposit` and `reposit` abstract methods.

Example of plugin implementation as follows

```ruby
# CapacityKeeper::Plugin must be inherited.
class TestPlugin < CapacityKeeper::Plugin

  # Define configs
  config :max, 10

  @@counter = 0

  # @override
  def reservable?
    # check current counter is not over max value
    @@counter <= configs[:max]
  end

  # @override
  def deposit
    # enqueue counter
    @@counter += 1
  end

  # @override
  def reposit
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
    # enclose with within_capacity method, and assign plugin class for keeping capacity
    within_capacity(plugin: TestPlugin) do
      # some system-unfriendly method
      innocent_method
    end
  end
end
```

### Exection sequence

1. Execute `reservable?` of your plugin implementation for capacity satisfation check
1. If reservable,
    1. Execute `deposit` of your plugin implementation
    1. __Execute your assigned block__
    1. Execute `reposit` of your plugin implementation


## Use runtime options

If your plugin class want to refer `@opts` variable, please assign `opts` argument of `within_capacity` method calling.

```ruby
require 'capacity_keeper'

class Example
  include CapacityKeeper

  def xxx
    within_capacity(plugin: TestPlugin, opts: { hello: 'world' }) do
      innocent_method
    end
  end
end
```

`@opts` variable can be refered from your plugin class.

```ruby
class TestPlugin < CapacityKeeper::Plugin

  option :max, 10

  @@counter = 0

  # @override
  def reservable?
    puts @opts.inspect  # @opts variable can be refered => { hello: 'world' }
    @@counter <= options[:max]
  end

  # @override
  def deposit
    @@counter += 1
  end

  # @override
  def reposit
    @@counter -= 1 if @@counter > 0
  end
end
```


## Capacity keeping with multi plugins

You can assign multi plugins by calling `add_plugin` method.

```ruby
within_capacity(plugin: PluginA).add_plugin(PluginB).add_plugin(PluginC) do
  # applied PluginA and PluginB and PluginC
  innocent_method(value)
end
```

### Exection sequence

1. Execute `reservable?` of PluginA for capacity satisfation check
1. Execute `reservable?` of PluginB for capacity satisfation check
1. Execute `reservable?` of PluginC for capacity satisfation check
1. If reservable on all plugins,
    1. Execute `deposit` of PluginA
    1. Execute `deposit` of PluginB
    1. Execute `deposit` of PluginC
    1. __Execute your assigned block__
    1. Execute `reposit` of PluginA
    1. Execute `reposit` of PluginB
    1. Execute `reposit` of PluginC

### Add some plugins under specific conditions

if you want to add some plugins under specific conditions, you can use `CapacityKeeper::Keepers#perform` method.

```ruby
str = 'C'

keepers = within_capacity(plugin: PluginA)
if str == 'B'
  keepers.add_plugin(PluginB)
end
if str == 'C'
  keepers.add_plugin(PluginC)
end

keepers.perform do
  # applied PluginA and PluginC
  innocent_method(value)
end
```


## Configurations
Default keeper configuration on your app using `CapacityKeeper.configure`

```ruby
CapacityKeeper.configure do |config|
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
