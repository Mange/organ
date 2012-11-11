require 'matching_file'
require 'episode_file'

class DSL
  def initialize
    @dir_stack = [Dir.new(Dir.pwd)]
  end

  def directory(path)
    new_path = File.expand_path(path, current_directory.path)
    @dir_stack << Dir.new(new_path)
    yield
  ensure
    @dir_stack.pop
  end

  def current_directory
    @dir_stack.last
  end

  def match_episode(name)
    match EpisodeFile.pattern(name) do |file|
      yield file.extend(EpisodeFile)
    end
  end

  def match(pattern)
    directory = current_directory
    directory.each do |name|
      basename = File.basename(name)
      if (matches = pattern.match(basename))
        yield MatchingFile.new(directory, basename), matches
      end
    end
  end
end
