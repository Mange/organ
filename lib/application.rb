require 'recipe'
require 'ui'

class Application
  def self.run
    new.run
  end

  def initialize(ui = ConsoleUI.new)
    @ui = ui
  end

  def run
    if File.exist? recipe_file
      Recipe.load(recipe_file).run(@ui)
    else
      @ui.no_recipe
    end
  end

  private
  def recipe_file
    @recipe_file ||= File.expand_path '~/.organrc'
  end
end
