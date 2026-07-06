# Chronar

<!-- [![Gem Version](https://badge.fury.io/rb/chronar.svg?icon=si%3Arubygems)](https://rubygems.org/gems/chronar) -->
[![CI](https://github.com/trinistr/Chronar/actions/workflows/CI.yaml/badge.svg)](https://github.com/trinistr/Chronar/actions/workflows/CI.yaml)

> [!TIP]
> You may be viewing documentation for an older (or newer) version of the gem than intended. Look at [Changelog](https://github.com/trinistr/Chronar/blob/main/CHANGELOG.md) to see all versions, including unreleased changes.

***

A prototype esoteric programming language based on splitting timelines.

## Table of contents

- [Installation](#installation)
- [Usage](#usage)
- [Development](#development)
- [Contributing](#contributing)
- [License](#license)

## Installation

Install the gem:

```sh
gem install chronar
```

## Usage

> [!NOTE]
> - Latest documentation from `main` branch is automatically deployed to [GitHub Pages](https://trinistr.github.io/chronar).
> - Documentation for published versions is available on [RubyDoc](https://rubydoc.info/gems/chronar).

TODO: Write usage instructions here

## Development

After checking out the repo, run `bundle install` to install dependencies. Then, run `rake spec` to run the tests, `rake rubocop` to lint code and check style compliance, `rake rbs` to validate signatures or just `rake` to do everything above. There is also `rake steep` to check typing, and `rake docs` to generate YARD documentation.

You can also run `bin/console` for an interactive prompt that will allow you to experiment, or `bin/benchmark` to run a benchmark script and generate a StackProf flamegraph.

To install this gem onto your local machine, run `rake install`.

To release a new version, run `rake version:{major|minor|patch}`, and then run `rake release`, which will build the package and push the `.gem` file to [rubygems.org](https://rubygems.org). After that, push the release commit and tags to the repository with `git push --follow-tags`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/trinistr/chronar.

**Checklist for a new or updated feature**

- Running `rake spec` reports 100% coverage (unless it's impossible to achieve in one run).
- Running `rake rubocop` reports no offenses.
- Running `rake steep` reports no new warnings or errors.
- Tests cover the behavior and its interactions. 100% coverage *is not enough*, as it does not guarantee that all code paths are tested.
- Documentation is up-to-date: generate it with `rake docs` and read it.
- "*CHANGELOG.md*" lists the change if it has impact on users.
- "*README.md*" is updated if the feature should be visible there.

## License

This gem is available as open source under the terms of the MIT License, see [LICENSE.txt](https://github.com/trinistr/chronar/blob/main/LICENSE.txt).
