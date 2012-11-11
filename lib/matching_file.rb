# encoding: UTF-8
require 'fileutils'

class MatchingFile
  attr_reader :name, :path

  def initialize(path, ui)
    @ui = ui
    @path = path
    @name = File.basename path
  end

  def move_to(destination_dir, new_name = @name)
    new_dir = File.expand_path destination_dir
    new_path = File.join new_dir, new_name
    unless File.exist? new_path
      FileUtils.mkpath new_dir
      @ui.moving_file @name, destination_dir
      FileUtils.mv @path, new_path
    else
      @ui.file_conflict @name, destination_dir, :exist
    end
  end
end
