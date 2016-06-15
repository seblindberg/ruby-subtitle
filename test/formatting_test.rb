require 'test_helper'

describe Subtitle::Formatting do
  subject { Subtitle::Formatting }
  
  describe 'creating a formatting block' do    
    it 'has no formatting initially' do
      formatting = subject.new
      
      refute formatting.bold?
      refute formatting.italic?
      refute formatting.underline?
      refute formatting.color
      refute formatting.font_name
      refute formatting.font_size
    end
    
    it 'accepts a hash of initial formatting' do
      formatting = subject.new bold: true, italic: true
      
      assert formatting.bold?
      assert formatting.italic?
      refute formatting.underline?
    end
  end
  
  
  describe '#apply' do
    before do 
      @formatting = subject.new
    end
    
    it 'applies font weight' do
      @formatting.apply bold: true
      assert @formatting.bold?
    end
    
    it 'applies font style' do
      @formatting.apply italic: true
      assert @formatting.italic?
    end
    
    it 'applies text decoration' do
      @formatting.apply underline: true
      assert @formatting.underline?
    end
    
    it 'can set and unset multiple properties' do
      @formatting.apply bold: true, italic: true
      
      assert @formatting.bold?
      assert @formatting.italic?
      refute @formatting.underline?
      
      @formatting.apply bold: false, underline: true
      
      refute @formatting.bold?
      assert @formatting.italic?
      assert @formatting.underline?
    end
    
    it 'returns itself' do
      assert_equal @formatting, @formatting.apply({})
    end
  end
end