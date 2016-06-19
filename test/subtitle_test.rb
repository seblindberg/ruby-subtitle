require 'test_helper'

describe Subtitle do
  subject { Subtitle }
  let(:subtitle) { subject.new }
  
  
  it 'has a version number' do
    refute_nil subject::VERSION
  end
  
  
  it 'has no lines when initially created' do
    assert_nil subtitle.first
    assert_nil subtitle.last
    
    assert_equal 0, subtitle.count
  end
  
  
  describe '#add' do
    it 'adds a line' do
      assert_nil subtitle.first
      line = subtitle.add 1..2
      assert_kind_of subject::Line, subtitle.first
      assert_equal line, subtitle.first
      assert_equal 1, subtitle.count
      #assert line.first?
      #assert line.last?
    end
    
    it 'adds many lines' do
      3.times {|t| subtitle.add t..(t+1) }
      assert_equal 3, subtitle.count
    end
  end
  
  
  it 'has no lines when all of them are removed' do
    assert_nil subtitle.first
    subtitle.add 1..2
    refute_nil subtitle.first
    subtitle.delete_at 0
    assert_nil subtitle.first
  end
end
