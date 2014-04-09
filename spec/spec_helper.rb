require 'fakefs/safe'
require 'fakefs/spec_helpers'

RSpec.configure do |c|
  c.treat_symbols_as_metadata_keys_with_true_values = true

  c.before(:each) do
    FakeFS.activate!
  end

  c.after(:each) do
    FakeFS.deactivate!
  end
end

def spec_resource(name)
  FakeFS.deactivate!
  contents = Pathname.new(__FILE__).dirname .join('resources').join(name).read
  FakeFS.activate!
  contents
end
