require "helper"
require "fluent/plugin/filter_swarm_metadata.rb"

class SwarmMetadataFilterTest < Test::Unit::TestCase
  setup do
    Fluent::Test.setup
  end

  test "failure" do
    flunk
  end

  private

  def create_driver(conf)
    Fluent::Test::Driver::Filter.new(Fluent::Plugin::SwarmMetadataFilter).configure(conf)
  end
end
