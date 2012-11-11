# encoding: UTF-8
require 'spec_helper'
require 'dsl'

describe DSL do
  let(:dsl) { DSL.new }
  before(:each) { path(".").create_directory }

  describe "directory" do
    it "defaults to current working directory" do
      dsl.current_directory.path.should == Dir.pwd
    end

    it "sets the current directory in the block" do
      path("a_dir").create_directory
      dsl.directory("a_dir") do
        dsl.current_directory.path.should == path("a_dir").expand_path
      end
    end

    it "can be nested" do
      path("parent/child").create_directory
      path("child").create_directory
      dsl.directory("parent") do
        dsl.directory("child") do
          dsl.current_directory.path.should == path("parent/child").expand_path
        end
        dsl.current_directory.path.should == path("parent").expand_path
      end
    end

    it "cancels nesting when given absolute paths" do
      path("/global/path").create_directory
      path("parent").create_directory

      dsl.directory("parent") do
        dsl.directory("/global/path") do
          dsl.current_directory.path.should == path("/global/path").expand_path
        end
        dsl.current_directory.path.should == path("parent").expand_path
      end
    end
  end
end
