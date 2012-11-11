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
    @color_scheme = HighLine::ColorScheme.new do |cs|
      cs[:action]    = [:green]
      cs[:directory] = [:blue]
      cs[:error]     = [:red]
      cs[:file]      = [:yellow]
    end
  end

  def no_recipe
    error "No recipe found"
  end

  def moving_file(name, destination_dir)
    display [
      color("Moving", :action),
      color(name, :file),
      "→",
      color(destination_dir, :directory)
    ].join " "
  end

  def moving_file_failed(name, destination_dir, error_type)
    error = {
      exist: "exists already",
    }[error_type]

    display [
      color("Cannot move", :error),
      color(name, :file),
      "→",
      color(destination_dir, :directory),
      color("(#{error})", :error)
    ].join " "
  end

  private
  def error(message)
    display color(message, :error)
  end

  def display(message)
    output_stream.puts message
  end

  def color(string, color)
    HighLine.color(string, @color_scheme[color] || color)
  end
end
