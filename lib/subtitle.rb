require 'subtitle/version'
require 'subtitle/line_set'
require 'subtitle/nil_line'
require 'subtitle/line'
require 'subtitle/formatting'


class Subtitle
  include LineSet
  
  attr_reader :last_line
    
  def initialize
    # The actual first line is a helper object that allows
    # the #add method to be more general
    @first_line = NilLine.new
    # Point to the first line
    @last_line  = @first_line
  end
  
  
  def add time_span, text = ''
    @last_line = Line.new time_span, text, previous_line: @last_line
  end
  
  
  def first_line
    @first_line.next
  end
end
