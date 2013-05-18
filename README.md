# MultiDir

[![Gem Version](https://badge.fury.io/rb/multi_dir.png)](http://badge.fury.io/rb/multi_dir)
[![Build Status](https://travis-ci.org/jgraichen/multi_dir.png?branch=master)](https://travis-ci.org/jgraichen/multi_dir)
[![Coverage Status](https://coveralls.io/repos/jgraichen/multi_dir/badge.png?branch=master)](https://coveralls.io/r/jgraichen/multi_dir?branch=master)
[![Code Climate](https://codeclimate.com/github/jgraichen/multi_dir.png)](https://codeclimate.com/github/jgraichen/multi_dir)
[![Dependency Status](https://gemnasium.com/jgraichen/multi_dir.png)](https://gemnasium.com/jgraichen/multi_dir)

**MultiDir** allow libraries and frameworks to request paths in a semantic
way. This allows administrators to define real paths in one global
standardized way.

No more `Rails.root.join *%w(tmp uploaded)` anymore. Give administrators the
freedom to link the temp directory to `/tmp/myapp` or any other system
specific place by just using `MultiDir.tmp.join 'uploaded'`.

*Note: MultiDir as a library is still under development but the concept sounds nice.*

## Installation

Add this line to your application's Gemfile:

    gem 'multi_dir'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install multi_dir

## Usage

### For All

MultiDir allows to define any semantic path your app, library or framework may
need. By default the following paths are specified:

```
MultiDir.bin    # => 'bin'
MultiDir.lib    # => 'lib'
MultiDir.tmp    # => 'tmp'
MultiDir.cache  # => 'tmp/cache'
MultiDir.files  # => 'files'
MultiDir.config # => 'config
```

### For Administrators

**MultiDir** provides everything you need to integrate some hipster app into
your well known and proven operating system structure. It allows you to
specify which content should live where without manual patching every piece of
code.

Create or edit `dirs.yml` in the application root directory (or whereever
you're running the app) or specific the path using `MULTI_DIR_CONFIG` env
variable with the following content:

```yaml
paths:
  tmp: /tmp/myapp-srv2
  files: /mnt/nfs2/storage
  cache: /var/cache/apps/myapp
  log: /var/log/myapp
```

This file allows you to specify the base paths for the application.

### For Developers

**MultiDir** makes you a developer loved by administrators as you given them
the freedom to adjust you app or library according there needs. It also makes
you happy reaching another stage of more semantic programming.

You can just use **MultiDir** like you've used `Rails.root.join` in the past.

See the following examples:

```ruby
# Request a specific file
MultiDir.cache.join *%(pdfgen page5.pdf) # => "cache/pdfgen/page5.pdf"

# Request a file with a temporary name
MultiDir.tmp.temp_file ['basename', '.jpg'] # => "tmp/basename74hf4727f834.jpg"

# Get list of files in a additional configurable directory
MultiDir.cache[:uploads].glob '**/*.zip' # This allows admins to configure a special path for :uploads
                                         # that if not given will be placed in 'cache'.
                                         # => ["/media/uploads/a/virus.zip", "/media/uploads/attachments/ppt.zip"]
```

You can even define your own new top level *semantic path*:

```ruby
MultiDir::Paths.define :uploads, in: :tmp
```

This allows you to use `uploads` as a top level path that will be placed in `tmp` if not configured otherwise:

```ruby
MultiDir.uploads.join 'abrng.pdf' # => "/tmp/uploads/abrng.pdf"
```

*More features will follow.*

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Add specs for your feature
4. Implement your feature
5. Check that all specs are passing
6. Commit your changes (`git commit -am 'Add some feature'`)
7. Push to the branch (`git push origin my-new-feature`)
8. Create new Pull Request

## License

Copyright (c) 2013 Jan Graichen - MIT License
