require "spec_helper"
require "recipe"

describe Recipe do
  include FakeFS::SpecHelpers

  it "can load files" do
    path("path/to/file").write "contents"
    Recipe.should_receive(:new).with("contents", "path/to/file").and_return "instance"
    Recipe.load("path/to/file").should == "instance"
  end

  it "can run the contents using the DSL" do
    dsl = double "DSL"
    ui = double "an UI"

    DSL.should_receive(:new).with(ui).and_return dsl

    dsl.should_receive(:foo)
    Recipe.new("foo").run(ui)
  end
end
