# encoding: UTF-8
require 'spec_helper'
require 'singleton'

describe ApplicationEvents do
  class TestApplication
    include Singleton

    extend ApplicationEvents
    attr_reader :output

    def initialize
      reset
    end

    def reset
      @output = ""
    end

    def display(message)
      @output << message
    end
  end

  def output_after_event(name, *args)
    TestApplication.public_send name, *args
    TestApplication.instance.output
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
end
