require 'test_helper'

describe Subtitle::LineSet do
  # Test the Line Set through the Line class which
  # implements it
  subject { Subtitle::Line }
  
  before do
    @first_line = subject.new 1..2, 1
    @last_line  = (2..10).inject(@first_line) do |prev_line, index|
      subject.new index..(index + 1), index, previous_line: prev_line
    end
  end
  
  describe '#each' do
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
  
  
  describe '#first' do
    it 'returns the first n lines from the set' do
      lines = @first_line.first 4
      assert_equal 4, lines.count
    end
    
    it 'returns lines after a given time' do
      line = @first_line.first after: @first_line
      assert_equal @first_line.next, line
    end
    
    it 'returns n lines after a given time' do
      lines = @first_line.first 2, after: @first_line
      assert_equal 2, lines.count
      assert_equal @first_line.next,      lines[0]
      assert_equal @first_line.next.next, lines[1]
    end
    
    it 'returns no line when given the last' do
      refute @first_line.first after: @last_line
    end
    
    it 'truncates the resulting array when there are not enough lines' do
      lines = @first_line.first 20
      assert_equal 10, lines.count
    end
  end
  
  
  describe '#last' do
    it 'returns the last line' do
      assert_equal @last_line, @first_line.last
    end
    
    it 'returns the last line before a given time' do
      assert_equal @last_line.previous, 
          @first_line.last(before: @last_line.begin)
    end
    
    it 'returns the last line before a given line' do
      assert_equal @last_line.previous, @first_line.last(before: @last_line)
    end
    
    it 'returns no line when given the first' do
      refute @first_line.last(before: @first_line)
    end
    
    it 'returns the n last lines when given an integer n' do
      lines = @first_line.last 2
      assert_equal 2, lines.count
      assert_equal @last_line.previous, lines[0]
      assert_equal @last_line,          lines[1]
    end
    
    it 'truncates the resulting array when there are not enough lines' do
      lines = @first_line.last 20
      assert_equal 10, lines.count
    end
  end
end