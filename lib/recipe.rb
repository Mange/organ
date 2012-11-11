require 'dsl'

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
    if @filename
      context.instance_eval(@contents, @filename)
    else
      context.instance_eval(@contents)
    end
  end
end
