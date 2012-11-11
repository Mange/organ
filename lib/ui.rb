# encoding: UTF-8
require 'highline'

class UI
end

class TestUI < UI
  attr_reader :messages
  def initialize(*) @messages = [] end
  def method_missing(*call) @messages << call end
  def respond_to?(*) true end
end

class ConsoleUI < UI
  attr_reader :output_stream

  def initialize(output = $stdout)
    @output_stream = output
  end

  def no_recipe
    error "No recipe found"
  end

  def moving_file(name, destination_dir)
    display [
      color_action("Moving"),
      color(name, :yellow),
      "→",
      color_directory(destination_dir)
    ].join " "
  end

  def moving_file_failed(name, destination_dir, error_type)
    error = {
      exist: "exists already",
    }[error_type]

    display [
      color("Cannot move", :red),
      color(name, :yellow),
      "→",
      color_directory(destination_dir),
      color("(#{error})", :red)
    ].join " "
  end

  private
  def error(message)
    display color(message, :red)
  end

  def color_action(action)
    color action, :green
  end

  def color_directory(name)
    color name, :blue
  end

  def display(message)
    output_stream << message
  end

  def color(string, *colors)
    HighLine.color(string, *colors)
  end
end
