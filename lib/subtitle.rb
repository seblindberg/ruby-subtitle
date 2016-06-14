require 'subtitle/version'
require 'subtitle/line'
require 'subtitle/formatting'


class Subtitle
  include Enumerable
  
  def initialize
    @first_line = nil
    @last_line  = nil
  end
  
  def add time_span, text = '', format: []
    @last_line = Line.new time_span, text, previous_line: @last_line, 
        format: format
  end
  
  def each
    return unless line = @first_line
    
    loop do
      yield line
      line = line.next
    end
  end
end
