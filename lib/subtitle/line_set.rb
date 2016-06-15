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
      line = first_line
      
      # If after is given the lines that come before that
      # time should be skipped
      if after
        case after
        when Numeric
        when Line
          after = after.end
        else
          raise TypeError, "Unsupported type of after: #{after.inspect}"
        end
        
        begin
          line = line.next until line.after? after
        rescue StopIteration
          # There are no lines after the given time, so we
          # return
          return
        end
      end
      
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
      
      # Finally loop over the remaining lines
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
  end
end