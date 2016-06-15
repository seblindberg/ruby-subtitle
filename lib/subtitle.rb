require 'subtitle/version'
require 'subtitle/line_set'
require 'subtitle/line'
require 'subtitle/formatting'


class Subtitle
  include LineSet
  
  attr_reader :first_line
  
  def initialize
    # Always start with a blank first line
    @first_line = Line.new 0..0
    @last_line  = @first_line
  end
  
  def add time_span, text = ''
    @last_line = Line.new time_span, text, previous_line: @last_line
  end
end
