# encoding: UTF-8
require 'highline'

module ApplicationEvents
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

  def file_conflict(name, destination_dir, type)
    display [
      color("Conflict", :red),
      color(name, :yellow),
      "→",
      color_directory(destination_dir),
      color("(#{type})", :red)
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
    instance.display message if instance
  end

  def color(string, *colors)
    HighLine.color(string, *colors)
  end
end
