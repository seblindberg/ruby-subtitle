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
    
    # Begin
    #
    # Returns the start time of the subtitle line.
    #
    
    def begin
      @time_span.begin
    end
    
    alias_method :start, :begin
    
    
    # End
    #
    # Returns the end time of the subtitle line.
    #
    
    def end
      @time_span.end
    end
    
    
    # During?
    #
    # Test if the line is visible during the time given.
    #
    
    def during? time
      @time_span.cover? time
    end
    
    
    # Before?
    #
    # 
    #
    
    def before? time
      @time_span.end < time
    end
    
    
    # After?
    #
    # 
    #
    
    def after? time
      @time_span.begin > time
    end
    
    
    # Duration
    #
    # 
    #
    
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
    
    
    # Intersect
    #
    # Check if this line intersects with another line, a range or some other 
    # custom object. See #intersect for more details.
    #
    
    def intersect? time_span
      self & time_span > 0
    end
    
    
    # Next
    #
    # Get the line after this one. Raises a StopIteration exception if this line 
    # is the last.
    #
    
    def next
      raise StopIteration if last?
      @next_line
    end
    
    
    # Next =
    #
    # Protected setter of the next line. This method is only ment to be called 
    # by other lines when adding, moving or removing them.
    #
    
    protected def next= line
      @next_line = line
    end
    
    
    # Previous
    #
    # Get the previous line. Raises a StopIteration exception if this line is
    # the first.
    #
    
    def previous
      raise StopIteration if first?
      @prev_line
    end
    
    
    # Previous =
    #
    # Protected setter of the previous line. This method is only ment to be 
    # called by other lines when adding, moving or removing them.
    #
    
    protected def previous= line
      @prev_line = line
    end
    
    
    # First?
    #
    # 
    #
    
    def first?
      @prev_line.nil?
    end
    
    
    # Last?
    #
    # 
    #
    
    def last?
      @next_line.nil?
    end
  end
end