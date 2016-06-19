require 'subtitle/version'
require 'subtitle/formatting'
require 'subtitle/formatable'
require 'subtitle/line_set'
require 'subtitle/line'


class Subtitle
  include LineSet
    
  def initialize
    # The actual first line is a helper object that allows
    # the #add method to be more general
    @first_line = self
    # Point to the first line
    @last_line  = @first_line
  end
  
  
  def add time_span, text = ''
    @last_line = Line.new time_span, text, previous_line: @last_line
  end
  
  
  def next= line
    if @first_line == self
      @first_line = line
      define_singleton_method(:first_line) { @first_line }
      define_singleton_method(:last_line)  { @last_line  }
    else
      line.previous = @last_line
      @last_line.next = line
      @last_line = line
    end
  end
  
  
  def first_line
    nil
  end
  
  
  def last_line
    nil
  end
end
