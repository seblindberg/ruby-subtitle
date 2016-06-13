# Subtitle Line
# 
# Represents the individual lines of a subtitle. Conceptually a line is one 
# frame of text and has a start and end time, between which it is shown.

module Subtitle
  class Line
    attr_reader :text
    
    def initialize time_span, text = '', previous_line: nil, format: {}
      @time_span = time_span
      @next_line = nil
      @prev_line = previous_line
      @text      = text.to_s
      
      if previous_line
        previous_line.next = self
      end
    end
    
    #
    # Returns the start time of the subtitle line.
    #
    
    def begin
      @time_span.begin
    end
    
    alias_method :start, :begin
    
    
    #
    # Returns the end time of the subtitle line.
    #
    
    def end
      @time_span.end
    end
    
    
    #
    # Test if the line is visible during the time given.
    #
    
    def during? time
      @time_span.cover? time
    end
    
    def before? time
      @time_span.end < time
    end
    
    def after? time
      @time_span.begin > time
    end
    
    def duration
      self.end - start
    end
    
    
    # Intersect
    #
    # Calculate the intersection with anything that has a beginning and and end. 
    # This can be another subtitle line, a range or some other custom object. As 
    # long as the range is numeric the intersecting time will be returned. If 
    # the given time span does not overlap the line the method will return 0.
    #
        
    def intersect time_span
      unless time_span.respond_to?(:begin) && time_span.respond_to?(:end)
        raise TypeError, 'time_span must have a beginning and an end'
      end
      
      begin_intr = [time_span.begin, self.begin].max
      end_intr   = [time_span.end,   self.end  ].min
      
      end_intr <= begin_intr ? 0 : end_intr - begin_intr
    end
    
    alias_method :&, :intersect
    
    
    def intersect? time_span
      self & time_span > 0
    end
    
    
    def next
      raise StopIteration if last?
    end
    
    def next= line
      @next_line = line
    end
    
    def previous
      raise StopIteration if first?
    end
    
    def first?
      @prev_line.nil?
    end
    
    def last?
      @next_line.nil?
    end
  end
end