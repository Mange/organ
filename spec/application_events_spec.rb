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

  def output
    TestApplication.instance.output
  end

  describe ".no_recipe" do
    it "displays a message" do
      TestApplication.no_recipe
      output.should include "No recipe found"
    end
  end

  describe ".moving_file" do
    it "displays a message" do
      TestApplication.moving_file "foo", "bar"
      output.should include "Moving foo → bar"
    end
  end
end
