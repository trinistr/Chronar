# gem-template

<!-- [![Gem Version](https://badge.fury.io/rb/gem_template.svg?icon=si%3Arubygems)](https://rubygems.org/gems/gem_template) -->
[![CI](https://github.com/trinistr/gem-template/actions/workflows/CI.yaml/badge.svg)](https://github.com/trinistr/gem-template/actions/workflows/CI.yaml)

> [!TIP]
> You may be viewing documentation for an older (or newer) version of the gem than intended. Look at [Changelog](https://github.com/trinistr/gem-template/blob/main/CHANGELOG.md) to see all versions, including unreleased changes.

***

<img src="logo.svg" alt="" align="right">

This is **gem template** with structure I find useful. It is periodically updated with new features and bug fixes.

> [!IMPORTANT]
> This is **not** actually a gem. There are released gems with similar names, but they are not related to this template in any way.

You can press ![Use this template](https://img.shields.io/badge/Use%20this%20template-1f833d) button at the top-right ↗️ of the GitHub page to create a new gem repository for yourself.

- After copying the template, replace "*gem-template*" with your gem name, `GemTemplate` with gem's module name, and rename "gem_template" files. Change username from "trinistr" to yours too!
- Don't forget to fill *gemspec* and this *README* with your own data. Of course, you also **have to** change copyright notice in "*LICENSE.txt*". Maybe even change the license.
- Make sure that [workflows](/.github/workflows) do what you want. Delete or change them as you see fit. However, removing [Zizmor workflow](/.github/workflows/zizmor.yaml) is not recommended, as it protects you against security vulnerabilities.
- Look at rulesets to be imported into the GitHub repository (Settings > Rules > Rulesets): [Default branch protection](/.github/Default%20branch%20protection.json), [Commit protection](/.github/Commit%20protection.json) and [Tag protection](/.github/Tag%20protection.json). These files are not needed after configuring the repository.

> [!NOTE]
> **This template is dedicated to the public domain under the terms of [CC0](https://creativecommons.org/publicdomain/zero/1.0/).**

## Table of contents

- [Installation](#installation)
- [Usage](#usage)
- [Development](#development)
- [Contributing](#contributing)
- [License](#license)

## Installation

Add to your application's Gemfile:

```ruby
gem "gem-template", github: "trinistr/gem-template"
```

## Usage

> [!NOTE]
> - Latest documentation from `main` branch is automatically deployed to [GitHub Pages](https://trinistr.github.io/gem-template).
> - Documentation for published versions is available on [RubyDoc](https://rubydoc.info/gems/gem-template).

TODO: Write usage instructions here

## Development

After checking out the repo, run `bundle install` to install dependencies. Then, run `rake spec` to run the tests, `rake rubocop` to lint code and check style compliance, `rake rbs` to validate signatures or just `rake` to do everything above. There is also `rake steep` to check typing, and `rake docs` to generate YARD documentation.

You can also run `bin/console` for an interactive prompt that will allow you to experiment, or `bin/benchmark` to run a benchmark script and generate a StackProf flamegraph.

To install this gem onto your local machine, run `rake install`.

To release a new version, run `rake version:{major|minor|patch}`, and then run `rake release`, which will build the package and push the `.gem` file to [rubygems.org](https://rubygems.org). After that, push the release commit and tags to the repository with `git push --follow-tags`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/trinistr/gem-template.

**Checklist for a new or updated feature**

- Running `rake spec` reports 100% coverage (unless it's impossible to achieve in one run).
- Running `rake rubocop` reports no offenses.
- Running `rake steep` reports no new warnings or errors.
- Tests cover the behavior and its interactions. 100% coverage *is not enough*, as it does not guarantee that all code paths are tested.
- Documentation is up-to-date: generate it with `rake docs` and read it.
- "*CHANGELOG.md*" lists the change if it has impact on users.
- "*README.md*" is updated if the feature should be visible there.

## License

This gem is available as open source under the terms of the MIT License, see [LICENSE.txt](https://github.com/trinistr/gem-template/blob/main/LICENSE.txt).
