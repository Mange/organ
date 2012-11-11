require 'matching_file'
require 'episode_file'

class Recipe
  def self.load(path)
    new File.read(path), path
  end

  def initialize(contents, filename = nil)
    @contents = contents
    @filename = filename
  end

  def run
    context = DSL.new
    context.instance_eval(@contents, @filename)
  end

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
end
