# encoding: UTF-8
require 'spec_helper'
require 'ui'

describe ConsoleUI do
  let(:output) { StringIO.new }
  let(:ui) { ConsoleUI.new(output) }

  before do
    HighLine.stub use_color?: false
  end

  def output_after_event(name, *args)
    ui.send(name, *args)
    output.string
  end

  describe ".no_recipe" do
    it "displays a message" do
      output_after_event(:no_recipe).should include "No recipe found"
    end
  end

  describe ".moving_file" do
    it "displays a message" do
      output_after_event(:moving_file, "A", "B").should include "Moving A → B"
    end
  end

  describe ".moving_file_failed" do
    it "displays a message" do
      output_after_event(:moving_file_failed, "A", "B", :exist).should include(
        "Cannot move A → B (exists already)"
      )
    end
  end
end
