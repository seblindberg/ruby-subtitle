require 'subtitle/version'
require 'subtitle/formatting'
require 'subtitle/line_set'
require 'subtitle/line_set/item'
require 'subtitle/line_set/first'
require 'subtitle/line_set/last'
require 'subtitle/line'


class Subtitle
  include LineSet
    
  def initialize
    # The actual first line is a helper object that allows
    # the #add method to be more general
    @first_line = LineSet::First.new
    # Point to the first line
    @last_line  = @first_line.next!
  end
  
  
  def add time_span, text = ''
    Line.new time_span, text, next_line: @last_line
  end
    
  
  protected def first_line
    @first_line
  end
  
  
  protected def last_line
    @last_line
  end
end
