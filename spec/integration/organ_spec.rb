# encoding: UTF-8
require 'spec_helper'
require 'stringio'

require 'application'

describe "Organ" do
  let(:output) { StringIO.new }

  def given_recipe(contents)
    path("~/.organrc").write(contents)
  end

  it "prints warning when no recipe exist" do
    Application.run(output)
    output.string.should include("No recipe found")
  end

  it "moves files according to patterns" do
    path('~/path/Fun Times.S03E77.scene.wow.so.cool.mkv').create_file

    given_recipe <<-RUBY
      directory "~/path" do
        match_episode "fun times" do |file|
          file.move_to "~/otherpath/Fun times/Season \#{file.season}"
        end
      end
    RUBY

    Application.run(output)
    path("~/otherpath").should be_directory
    path("~/otherpath/Fun times/Season 3").should be_directory

    output_string = output.string
    output_string.should include "Moving Fun Times.S03E77.scene.wow.so.cool.mkv → ~/otherpath/Fun times/Season 3"
  end
end
