require 'test_helper'

describe Subtitle::Line do
  subject { Subtitle::Line }
  
  let(:start_at)  { 1000 }
  let(:end_at)    { 1950 }
  let(:time_span) { start_at..end_at }
  let(:text)      { "Test line\ntesting lines" }
  let(:line)      { subject.new time_span, text }
  
  describe 'creating lines' do
    it 'accepts the minimum amount of arguments' do
      line = subject.new time_span, text
      
      assert_equal start_at, line.begin
      assert_equal end_at,   line.end
      assert_equal text,     line.text
    end
    
    it 'makes sure text is a String' do
      line = subject.new time_span, 42
      assert_kind_of String, line.text
    end
    
    it 'is both the first and last line when none where given' do
      assert line.last?
      assert line.first?
    end
  end
  
  
  describe '#during?' do
    it 'returns true for times between the start and end time' do
      assert line.during? start_at
      assert line.during? end_at
    end
    
    it 'returns false for times before and after the start and end time' do
      refute line.during? (start_at - 1)
      refute line.during? (end_at + 1)
    end
  end
  
  
  describe '#before?' do
    it 'is before times after its end' do
      assert line.before? (end_at)
    end
    
    it 'is not before times before its end' do
      refute line.before? (end_at - 1)
    end
  end
  
  
  describe '#after?' do
    it 'is after times before its start' do
      assert line.after? (start_at)
    end
    
    it 'is not after times before its start' do
      refute line.after? (start_at + 1)
    end
  end
  
  
  describe '#duration' do
    it 'calculates its duration' do
      assert_equal (end_at - start_at), line.duration
    end
  end
  
  
  describe '#intersect' do
    it 'requires that the time span responds to #begin and #end' do
      assert_raises(TypeError) { line.intersect 5 }
    end
    
    it 'intersects with its own time span completely' do
      assert_equal line.duration, line.intersect(line)
      assert_equal line.duration, line.intersect(time_span)
    end
    
    it 'intersects partially with overlapping ranges' do
      assert_operator 0, :<, line.intersect((start_at + 1)..(end_at + 1))
      assert_operator 0, :<, line.intersect((start_at + 1)..(end_at - 1))
      assert_operator 0, :<, line.intersect((start_at - 1)..(end_at - 1))
    end
    
    it 'does not intersect with non overlapping ranges' do
      assert_equal 0, line.intersect((start_at - 1)..start_at)
      assert_equal 0, line.intersect(end_at..(end_at + 1))
    end
    
    it 'is aliased to #&' do
      assert_equal line.duration, (line & line)
    end
  end
  
  
  describe '#intersect?' do
    it 'intersects with itself' do
      assert line.intersect?(line)
    end
    
    it 'intersects with overlapping ranges' do
      assert line.intersect?((start_at + 1)..(end_at + 1))
    end
    
    it 'does not intersect with non overlapping ranges' do
      refute line.intersect?((start_at - 1)..start_at)
    end
  end
  
  
  describe '#delete' do
    before do
      @first_line = subject.new 1..2
      @middle_line = subject.new 2..3, previous_line: @first_line
      @last_line = subject.new 3..4, previous_line: @middle_line
    end
    
    it 'deletes the first line' do
      refute @middle_line.first?
      @first_line.delete
      assert @middle_line.first?
    end
    
    it 'deletes the middle line' do
      @middle_line.delete
      assert_equal @last_line, @first_line.next
      assert_equal @first_line, @last_line.previous
    end
    
    it 'deletes the last line' do
      refute @middle_line.last?
      @last_line.delete
      assert @middle_line.last?
    end
  end
  
  
  describe '#format' do
    it 'returns the formatting object' do
      f = line.format
      assert_kind_of Subtitle::Formatting, f
      assert_equal line.formatting.values.first, f
    end
    
    it 'allows for applying styles to the entire line' do
      f = line.format bold: true, italic: true
            
      assert f.bold?
      assert f.italic?
      refute f.underline?
    end
    
    it 'styles complete sections of the line' do
      f = line.format 0
      section = line.formatting.key f
      
      assert_equal 0,                    section.begin
      assert_equal text.index("\n") - 1, section.end
      
      f = line.format 1
      section = line.formatting.key f
      
      assert_equal text.index("\n") + 1, section.begin
      assert_equal text.length - 1,      section.end
    end
    
    it 'does not create new formatting objects for the same sections' do
      f = line.format 1..4
      refute_equal f, line.format(0..5)
      assert_equal f, line.format(1..4)
    end
  end
end