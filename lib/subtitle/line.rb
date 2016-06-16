# Subtitle Line
# 
# Represents the individual lines of a subtitle. Conceptually a line is one 
# frame of text and has a start and end time, between which it is shown.
#
# Each line can also be treated as a line set through its connection to its
# neighbouring lines. The #first_line and #last_line methods are implemented
# for this purpose and always return the line itself.
#

class Subtitle
  class Line
    include LineSet
    
    attr_reader :text, :formatting
    
    
    # Initialize
    #
    # Create a new line with a time span (requred range of
    # time), text a previous line and formatting options.
    
    def initialize time_span, text = '', previous_line: nil
      @time_span = time_span
      @next_line = nil
      @prev_line = previous_line
      @text      = text.to_s
      
      previous_line.next = self if previous_line
      
      @formatting = Hash.new do |list, section|
        list[section] = Formatting.new
      end
      
      self
    end
    
    
    # Begin
    #
    # Returns the start time of the subtitle line.
    
    def begin
      @time_span.begin
    end
    
    alias_method :start, :begin
    
    
    # End
    #
    # Returns the end time of the subtitle line.
    
    def end
      @time_span.end
    end
    
    
    # Duration
    #
    # The time span during which the line is visible.
    
    def duration
      self.end - start
    end
    
    
    # During?
    #
    # Ask if the line is visible at the given time.
    
    def during? time
      @time_span.cover? time
    end
    
    
    # Before?
    #
    # Returns true if the line is shown completely before a
    # given time.
    
    def before? time
      @time_span.end <= time
    end
    
    
    # After?
    #
    # Returns true if the line is shown completely after a
    # given time.
    
    def after? time
      @time_span.begin >= time
    end
    
    
    # Intersect
    #
    # Calculate the intersection with anything that has a beginning and and end. 
    # This can be another subtitle line, a range or some other custom object. As 
    # long as the range is numeric the intersecting time will be returned. If 
    # the given time span does not overlap the line the method will return 0.
        
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
    
    def intersect? time_span
      self & time_span > 0
    end
    
    
    # Next
    #
    # Get the line after this one. Raises a StopIteration exception if this line 
    # is the last.
    
    def next
      raise StopIteration if last?
      @next_line
    end
    
    
    # Next =
    #
    # Protected setter of the next line. This method is only ment to be called 
    # by other lines when adding, moving or removing them.
    
    protected def next= line
      @next_line = line
    end
    
    
    # Previous
    #
    # Get the previous line. Raises a StopIteration exception if this line is
    # the first.
    
    def previous
      raise StopIteration if first?
      @prev_line
    end
    
    
    # Previous =
    #
    # Protected setter of the previous line. This method is only ment to be 
    # called by other lines when adding, moving or removing them.
    
    protected def previous= line
      @prev_line = line
    end
    
    
    # First?
    #
    # Returns true if this is the first line in a sequence.
    
    def first?
      @prev_line.nil?
    end
    
    
    # Last?
    #
    # Returns true if this is the last line in a sequence.
    
    def last?
      @next_line.nil?
    end
    
    
    protected def first_line
      self
    end
    
    protected def last_line
      self
    end
    
    
    def delete
      # Get the lines on either side of this line and connect them up
      @next_line.previous = @prev_line unless last?
      @prev_line.next     = @next_line unless first?
    end
    
    
    # Format
    #
    # Accept the various styling options as named arguments.
    # Using apply to the scope of the formatting can be 
    # controlled as follows:
    # - nil applies to the entire line
    # - 0, 1, ... applies to the first, second and so on section of text 
    #   separated by new-line characters
    # - 0..n applies to the characters at index 0 through n
    
    def format section = nil, formatting = {}
      
      if Hash === section
        section, formatting = nil, section
      end
      
      # Convert supported section types to character ranges
      section = case section
      when NilClass
        0...@text.length
      
      when Range
        if section.begin < 0 || section.end >= @text.length
          raise RangeError, 
              'The range covers more than the text'
        end
        
        section
        
      when Fixnum
        offsets = @text.split("\n").map(&:length)
        
        if section >= offsets.count
          raise RangeError, 
              "The line does not contain #{section} sections"
        end
        
        from    = offsets[0...section].reduce(0) { |s,o| s + o + 1 }
        to      = from + offsets[section] - 1
        
        from..to
      
      else
        raise TypeError, 
            "Unknown formatting section: #{section.inspect}"
      end
      
      # Apply the formatting to the selected section of the
      # line text
      @formatting[section].apply formatting
    end
    
    
    # Inspect
    #
    # The default inspect method is problematic because of the way it recursivly 
    # expands the preivous and next lines. Therefore it is replaced.
    
    def inspect
      '#<%s:0x%x (%i..%i) "%s">' % [
        self.class.name, object_id, self.begin, self.end, self.text
      ]
    end
  end
end