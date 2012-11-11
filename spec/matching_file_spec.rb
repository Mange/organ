# encoding: UTF-8
require 'spec_helper'
require 'matching_file'

describe MatchingFile do
  def directory(dirpath = '~')
    Dir.new path(dirpath).tap { |dir| dir.create_directory }.to_s
  end

  before do
    Application.stub(moving_file: nil, file_conflict: nil)
  end

  it "has a directory" do
    dir = directory '/tmp/path'
    MatchingFile.new(dir, "foo").directory.should == dir
  end

  it "has a name" do
    MatchingFile.new(directory, "foobar").name.should == "foobar"
  end

  it "has a path" do
    dir = directory "/tmp"
    MatchingFile.new(dir, "good one").path.should == "/tmp/good one"
  end

  describe "moving file" do
    it "preserves the filename" do
      original = path("one/some_file").create_file
      path("two/nested").create_directory

      matching_file = MatchingFile.new original.directory, original.filename
      matching_file.move_to("two/nested")

      path("two/nested/some_file").should exist
      path("one/some_file").should_not exist
    end

    it "creates the path if not already existing" do
      original = path("one/some_file").create_file

      matching_file = MatchingFile.new original.directory, original.filename
      matching_file.move_to("two/nested/again")

      path("two/nested/again/some_file").should exist
    end

    it "allows an alternative filename to be entered" do
      original = path("one/some_file").create_file
      path("two/nested").create_directory

      matching_file = MatchingFile.new original.directory, original.filename
      matching_file.move_to "two/nested", "new_name"

      path("two/nested/new_name").should exist
    end

    it "signals the move to the application" do
      path("~/destination").create_directory
      original = path("path/to/original name").create_file
      matching_file = MatchingFile.new original.directory, original.filename

      Application.should_receive(:moving_file).with("original name", "~/destination")
      matching_file.move_to "~/destination"
    end

    describe "when target already exist" do
      before do
        @new_file = path("one/some_file").write "new file"
        @old_file = path("two/some_file").write "old file"
        @matching_file = MatchingFile.new @new_file.directory, @new_file.filename
      end

      it "does not move the file" do
        @matching_file.move_to @old_file.dirname

        @new_file.should exist
        @old_file.should exist
        @old_file.read.should == "old file"
      end

      it "signals the conflict to the application" do
        Application.should_receive(:file_conflict).with(
          @new_file.filename,
          @old_file.dirname,
          :exist
        )
        @matching_file.move_to @old_file.dirname
      end
    end
  end
end
