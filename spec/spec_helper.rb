require 'fakefs/spec_helpers'
require 'support/path_matchers'

$LOAD_PATH << File.expand_path("../../lib", __FILE__)

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.order = 'random'

  config.include FakeFS::SpecHelpers
  config.include PathHelpers
end
