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
    new_path = File.join new_dir, new_name
    unless File.exist? new_path
      FileUtils.mkpath new_dir
      Application.moving_file @name, destination_dir
      FileUtils.mv @path, new_path
    else
      Application.file_conflict @name, destination_dir, :exist
    end
  end
end
