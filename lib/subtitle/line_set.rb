# Line Set
#
# 

class Subtitle
  module LineSet
    # Include the regular enumerable for all the usual 
    # iteration methods
    include Enumerable
    
    
    # Each
    #
    # Method for iterating over lines in the forwards direction, with the option  
    # of only going over lines witin the time frame set by before and after.
    
    def each before: nil, after: nil
      # Create an enumerator unless a block was given
      unless block_given?
        return to_enum(__callee__, before: before, after: after)
      end
      
      # Start at this line      
      line = first after: after
      
      # Return if no lines start after the given time
      return if line.nil?
      
      # Decide what condition should be used for stoping
      # the iteration
      should_continue = case before
      when Numeric 
        proc{|l| l.before? before }
        
      when Line
        time = before.begin
        proc{|l| l.before? time }
        
      when NilClass 
        proc{|_| true }
        
      else
        raise TypeError, "Unsupported type of before: #{before.inspect}"
      end
      
      # Finally loop over the lines and yield each one to
      # the block
      loop do
        # Check if the loop should countinue running, given
        # the current line
        break unless should_continue[line]
        
        # Yield to the block and pass the line as an argument
        yield line
        
        # Move to the next line
        line = line.next
      end
    end
    
    
    # First
    #
    # Get the first line in the set that occurs after a given time. Note that 
    # this method overrides the standard Enumerable#first. The functionallity is 
    # ment to mirror the original, with the added ability to set the a lower 
    # bound on the start time of the lines.
    
    def first n = 1, after: nil
      
      # Initialize line and res in acordance with the value
      # of n
      line = first_line
      res  = nil
      
      return unless line
      
      # Find the first line that occurs after the given time,
      # if a time was in fact given
      if after
        case after
        when Numeric
        when Line
          after = after.end
        else
          raise TypeError, "Unsupported type of after: #{after.inspect}"
        end
        
        line = line.next until line.after? after
      end
      
      if n > 1
        res = Array.new n
        # Try to take n elements from line and forward and
        # put them in res
        n.times {|i| res[i] = line; line = line.next }
      else
        res = line
      end
      
    rescue StopIteration
      # Make sure to compact the array if more than one
      # element should be returned (n > 1). Since a 
      # StopIteration was raised we can assume that the 
      # array is not filled.
      res.compact! if res.is_a? Array
    ensure
      return res
    end
    
    
    # Last
    #
    # Get the last line in the set that occurs before a given time.
    
    def last n = 1, before: nil
      
      line      = nil
      next_line = first_line
      res       = nil
      
      return unless next_line
      
      # Create the condition for continuing the loop, given
      # a line
      should_continue = case before
      when Numeric
        proc{|l| l.before? before }
      when Line
        time = before.begin
        proc{|l| l.before? time }
      when NilClass
        proc{|_| true }
      else
        raise TypeError, "Unsupported type of before: #{before.inspect}"
      end
      
      # This loop will exit either when should_continue
      # returns false or when there are no more lines
      loop do
        break unless should_continue[next_line]
        line = next_line
        # Try to get the next line
        next_line = line.next
      end
      
      # line now contains the last line to occur before the
      # given time.
      
      if n > 1
        res = Array.new n
        # Try to take n lines and insert them, in reverse 
        # order, into res
        n.times {|i| res[n - i - 1] = line; line = line.previous }
      else
        res = line
      end
      
    rescue StopIteration
      # If a StopIteration was raised we can assume that
      # a) res is an array and b) it contains nil items
      res.compact!
    ensure
      return res
    end
    
    
    # Delete At
    #
    # Delete the line at the given offset, from the first line. If the offset is  
    # negative it is instead used "in reverse".
    
    def delete_at offset
      if offset >= 0
        line = first_line
        return unless line
        
        offset.times { line = line.next }
      else
        line = last_line
        return unless line
        
        (-offset - 1).times { line = line.previous }
      end
      
     
      
      line.delete
      
    rescue StopIteration
    end
  end
end