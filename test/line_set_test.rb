require 'test_helper'

describe Subtitle::LineSet do
  # Test the Line Set through the Line class which
  # implements it
  subject { Subtitle::Line }
  
  
  describe '#each' do
    before do
      @first_line = subject.new 1..2, 1
      @last_line  = (2..10).inject(@first_line) do |prev_line, index|
        subject.new index..(index + 1), index, previous_line: prev_line
      end
    end
    
    it 'enumerates lines before a time' do
      lines = @first_line.each(before: 5).count
      
      # The fourth line starts at 4 and ends at 5, so it is
      # the last that should be counted
      assert_equal 4, lines
    end
    
    it 'enumerates lines before a line' do
      # Count lines that end before the last line starts
      lines = @first_line.each(before: @last_line).count
      
      # All but the last line (9 in total) should be counted
      assert_equal 9, lines
    end
    
    it 'enumerates lines after a time' do
      # Count lines that start at or after 5
      lines = @first_line.each(after: 5).count
      
      # The fifth line starts at 5, which is considered to
      # occur after 5
      assert_equal 6, lines
    end
    
    it 'enumerates lines after a line' do
      # Count lines that start after the first lines has
      # ended
      lines = @first_line.each(after: @first_line).count
      assert_equal 9, lines
    end
  end
end