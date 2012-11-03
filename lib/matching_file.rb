# encoding: UTF-8
require 'fileutils'

class MatchingFile
  attr_reader :directory, :name, :path

  def initialize(directory, name)
    @directory = directory
    @name = name
    @path = File.join(directory.path, name)
  end

  def move_to(destination_dir, new_name = @name)
    new_dir = File.expand_path destination_dir
    FileUtils.mkpath new_dir
    Application.moving_file @name, destination_dir
    FileUtils.mv @path, File.join(new_dir, new_name)
  end
end
