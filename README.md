# organ #

`organ` is a small command that moves around files according to a recipe that you write yourself.

It was written mostly to test out different approaches to object oriented CLI programs, but I found it useful enough to use it in a cronjob on my machine. I release this codebase in the hopes that it might help someone else.

## Usage ##

Write your own recipe and save it as `~/.organrc`. Here's one example recipe:

```ruby
#!/bin/env organ
# vi: ft=ruby
require 'pathname'

library_base = Pathname.new "/home/shared/Library"

directory "#{ENV['HOME']}/Downloads" do
  directory "Series" do
    series = [
      "Black Mirror",
      "Robot Chicken",
      "The Good Wife",
    ]
    library = library_base.join "Series"

    series.each do |name|
      match_episode name do |file|
        file.move_to library.join(name, "Season #{file.season}")
      end
    end

    match_episode "The Killing" do |file|
      file.move_to "/home/shared/Videos/Series/The Killing (2011)/Season #{file.season}"
    end
  end

  directory "Music" do
    # ...
  end
end
```

The DSL is centered around matching files inside directories and then acting upon them. In the example above, `organ` would move episodes in "~/Downloads/Series" into their respective library locations. The episode matcher extracts season and episode number from the filename, so you can rename the files as well if you so wish.

## Developing ##

Install all dependencies with `bundle`. You can run tests by calling `bundle exec rspec`.

# License #

This code is public domain. Do with it as you wish!
