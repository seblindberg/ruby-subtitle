require 'test_helper'

describe Subtitle::LineSet do
  # Test the Line Set through the Line class which
  # implements it
  subject { Subtitle::Line }
  
  let(:n_lines) { 7 }
  
  before do
    @first_line = subject.new 1..2, 1
    @last_line  = (2..n_lines).inject(@first_line) do |prev_line, index|
      subject.new index..(index + 1), index, previous_line: prev_line
    end
  end
  
  describe '#each' do
    it 'enumerates lines before a time' do
      index = 5
      lines = @first_line.each(before: index).count
      
      # The fourth line starts at 4 and ends at 5, so it is
      # the last that should be counted
      assert_equal index - 1, lines
    end
    
    it 'enumerates lines before a line' do
      # Count lines that end before the last line starts
      lines = @first_line.each(before: @last_line).count
      
      # All but the last line (9 in total) should be counted
      assert_equal n_lines - 1, lines
    end
    
    it 'enumerates lines after a time' do
      # Count lines that start at or after 5
      index = 5
      lines = @first_line.each(after: index).count
      
      # The fifth line starts at 5, which is considered to
      # occur after 5
      assert_equal n_lines - index + 1, lines
    end
    
    it 'enumerates lines after a line' do
      # Count lines that start after the first lines has
      # ended
      lines = @first_line.each(after: @first_line).count
      assert_equal n_lines - 1, lines
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
      lines = @first_line.first (n_lines + 1)
      assert_equal n_lines, lines.count
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
      lines = @first_line.last (n_lines + 1)
      assert_equal n_lines, lines.count
    end
  end
  
  
  describe '#delete_at' do
    it 'deletes the first line when the offset is 0' do
      second_line = @first_line.next
      refute second_line.first?
      @first_line.delete_at 0
      assert second_line.first?
    end
    
    it 'deletes the second line when the offset is 1' do
      third_line = @first_line.next.next
      @first_line.delete_at 1
      assert_equal third_line, @first_line.next
    end
    
    it 'does not delete any line if the offset exceeds the line count' do
      lines_before_delete = @first_line.to_a
      @first_line.delete_at n_lines
      assert_equal lines_before_delete, @first_line.to_a
    end
    
    it 'deletes the last line when the offset is -1' do
      second_to_last_line = @last_line.previous
      refute second_to_last_line.last?
      @last_line.delete_at (-1)
      
      assert second_to_last_line.last?
    end
    
    it 'deletes the second to last line when the offset is -2' do
      third_to_last_line = @last_line.previous.previous
      @last_line.delete_at (-2)
      
      assert_equal third_to_last_line, @last_line.previous
    end
    
    it 'does not fail on empty sets' do
      empty_set = Subtitle.new
      assert_silent { empty_set.delete_at 0 }
    end
  end
end