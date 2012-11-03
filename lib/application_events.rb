# encoding: UTF-8
require 'highline'

module ApplicationEvents
  def moving_file(name, destination_dir)
    display [
      color("Moving", :green),
      color(name, :yellow),
      "→",
      color(destination_dir, :blue),
    ].join " "
  end

  private
  def display(message)
    instance.display message if instance
  end

  def color(string, *colors)
    HighLine.color(string, *colors)
  end
end
