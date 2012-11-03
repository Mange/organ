require 'highline'
require 'application_events'
require 'recipe'

class Application
  class << self
    attr_accessor :instance
  end

  def self.run(output=$stdout)
    raise "No instance should be set already!" if self.instance
    self.instance = new(output)
    self.instance.run
  ensure
    self.instance = nil
  end

  extend ApplicationEvents

  def initialize(output)
    @output = output
  end

  def display(message)
    @output.puts message
  end

  def run
    if File.exist? recipe_file
      Recipe.new(File.read(recipe_file), recipe_file).run
    else
      @output.puts HighLine.color("No recipe found", :yellow)
    end
  end

  private
  def recipe_file
    @recipe_file ||= File.expand_path '~/.organrc'
  end
end
