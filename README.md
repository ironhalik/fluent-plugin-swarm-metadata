# fluent-plugin-swarm-metadata

[Fluentd](https://fluentd.org/)

Filter plugin that allows flutentd to use Docker Swarm metadata.

## Installation

### RubyGems

```
$ gem install fluent-plugin-swarm-metadata
```

### Bundler

Add following line to your Gemfile:

```ruby
gem "fluent-plugin-swarm-metadata"
```

And then execute:

```
$ bundle
```

## Configuration

You can generate configuration template:

```
$ fluent-plugin-config-format filter swarm-metadata
```

You can copy and paste generated documents here.

## Copyright

* Copyright(c) 2020- Michał Weinert
* License
  * Apache License, Version 2.0
