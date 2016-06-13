require 'test_helper'

class SubtitleTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Subtitle::VERSION
  end
end
