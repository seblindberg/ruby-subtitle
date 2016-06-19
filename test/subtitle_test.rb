require 'test_helper'

describe Subtitle do
  subject { Subtitle }
  let(:subtitle) { subject.new }
  
  it 'has a version number' do
    refute_nil subject::VERSION
  end
  
  it 'has no lines when initially created' do
    assert_nil subtitle.first_line
    assert_nil subtitle.last_line
    
    assert_equal 0, subtitle.count
  end
  
  describe '#add' do
    it 'adds a line' do
      assert_nil subtitle.first_line
      subtitle.add 1..2
      assert_kind_of subject::Line, subtitle.first_line
      assert_equal 1, subtitle.count
    end
  end
end
