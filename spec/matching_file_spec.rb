# encoding: UTF-8
require 'spec_helper'
require 'matching_file'

describe MatchingFile do
  let(:ui) { double }

  before do
    ui.stub moving_file: nil, file_conflict: nil
  end

  def matching_file(path)
    MatchingFile.new(path, ui)
  end

  it "has a name" do
    matching_file("~/foobar").name.should == "foobar"
  end

  it "has a path" do
    matching_file("/tmp/good one").path.should == "/tmp/good one"
  end

  describe "moving file" do
    it "preserves the filename" do
      original = path("one/some_file").create_file
      path("two/nested").create_directory

      matching_file = matching_file original.to_s
      matching_file.move_to("two/nested")

      path("two/nested/some_file").should exist
      path("one/some_file").should_not exist
    end

    it "creates the path if not already existing" do
      original = path("one/some_file").create_file

      matching_file = matching_file original.to_s
      matching_file.move_to("two/nested/again")

      path("two/nested/again/some_file").should exist
    end

    it "allows an alternative filename to be entered" do
      original = path("one/some_file").create_file
      path("two/nested").create_directory

      matching_file = matching_file original.to_s
      matching_file.move_to "two/nested", "new_name"

      path("two/nested/new_name").should exist
    end

    it "signals the move to the application" do
      path("~/destination").create_directory
      original = path("path/to/original name").create_file
      matching_file = matching_file original.to_s

      ui.should_receive(:moving_file).with("original name", "~/destination")
      matching_file.move_to "~/destination"
    end

    describe "when target already exist" do
      before do
        @new_file = path("one/some_file").write "new file"
        @old_file = path("two/some_file").write "old file"
        @matching_file = matching_file @new_file.to_s
      end

      it "does not move the file" do
        @matching_file.move_to @old_file.dirname

        @new_file.should exist
        @old_file.should exist
        @old_file.read.should == "old file"
      end

      it "signals the conflict to the application" do
        ui.should_receive(:file_conflict).with(
          @new_file.filename,
          @old_file.dirname,
          :exist
        )
        @matching_file.move_to @old_file.dirname
      end
    end
  end
end
