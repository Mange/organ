require "spec_helper"
require "recipe"

describe Recipe do
  include FakeFS::SpecHelpers

  it "can load files" do
    path("path/to/file").write "contents"
    Recipe.should_receive(:new).with("contents", "path/to/file").and_return "instance"
    Recipe.load("path/to/file").should == "instance"
  end

  describe "running" do
  end
end
