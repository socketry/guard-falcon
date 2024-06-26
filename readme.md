# Guard::Falcon

Efficiently runs a asynchronous Falcon server, restarting it as required by guard.

[![Development Status](https://github.com/socketry/guard-falcon/workflows/Test/badge.svg)](https://github.com/socketry/guard-falcon/actions?workflow=Test)

## Installation

Add this line to your application's Gemfile:

``` ruby
gem 'guard-falcon'
```

And then execute:

    $ bundle

## Usage

Falcon can restart very quickly and is ideal for use with guard. In your `Guardfile`:

``` ruby
guard :falcon do
end
```

## Contributing

We welcome contributions to this project.

1.  Fork it.
2.  Create your feature branch (`git checkout -b my-new-feature`).
3.  Commit your changes (`git commit -am 'Add some feature'`).
4.  Push to the branch (`git push origin my-new-feature`).
5.  Create new Pull Request.

### Developer Certificate of Origin

This project uses the [Developer Certificate of Origin](https://developercertificate.org/). All contributors to this project must agree to this document to have their contributions accepted.

### Contributor Covenant

This project is governed by the [Contributor Covenant](https://www.contributor-covenant.org/). All contributors and participants agree to abide by its terms.
