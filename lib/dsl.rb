require 'matching_file'
require 'episode_file'

class DSL
  def initialize
    @dir_stack = []
  end

  def directory(path)
    @dir_stack << Dir.new(path)
    yield
  ensure
    @dir_stack.pop
  end

  def match_episode(name)
    match EpisodeFile.pattern(name) do |file|
      yield file.extend(EpisodeFile)
    end
  end

  def match(pattern)
    directory = @dir_stack.last
    directory.each do |name|
      basename = File.basename(name)
      if (matches = pattern.match(basename))
        yield MatchingFile.new(directory, basename), matches
      end
    end
  end
end
