require 'rubygems'
require 'roo'
require 'iconv'

module CommentHelper

  class FlashCard
    attr_accessor :title, :content, :answer, :input 
    #private_class_method :new
    class << self
      attr_accessor :total_answer
    end
    
    def initialize(*args, &block)
       if self.class == FlashCard
          raise "Cannot instantiate an abstract class."
       end
       create(*args, &block)
    end
    private 
      def create(*args, &block)
         @title = args[0]
         @content = args[1]
         @answer = args[2]
         @input = args[3]
      end
       
  end
  class VocabularyCard < FlashCard
    attr_accessor :comment, :sinfo
    
    def initialize(*args, &block)
      super(*args, &block)
    end
    
    def rand_record
      count = Comment.all.count
      return_records = Comment.find_by_sql("select * from comments limit " + rand(1-(count-1)).to_s + ", 1")
      @comment = return_records[0]
    end
    
    def correct?
      @answer = @comment.answer
      @answer==@input
    end

    def excel_info
      #s = Openoffice.new("myspreadsheet.ods")      # creates an Openoffice Spreadsheet instance  
      file = File.join(Rails.root, 'public', 'translation.xls')
      s = Excel.new(file)           # creates an Excel Spreadsheet instance  
      #s = Google.new("myspreadsheetkey_at_google") # creates an Google Spreadsheet instance  
      #s = Excelx.new("myspreadsheet.xlsx")         # creates an Excel Spreadsheet instance for Excel .xlsx files  
      s.default_sheet = s.sheets.first  # first sheet in the spreadsheet file will be used  
        
      # s.sheet is an array which holds the names of the sheets within  
      # a spreadsheet.  
      # you can also write  
      # s.default_sheet = s.sheets[3] or  
      # s.default_sheet = 'Sheet 3'  
        
      s.cell(1,1)                                 # returns the content of the first row/first cell in the sheet  
      s.cell('A',1)                               # same cell  
      s.cell(1,'A')                               # same cell  
      s.cell(1,'A',s.sheets[0])                   # same cell  

      s.info                                      # prints infos about the spreadsheet file  
        
      s.first_row                                 # the number of the first row  
      s.last_row                                  # the number of the last row  
      s.first_column                              # the number of the first column  
      s.last_column                               # the number of the last column  
        
      # limited font information is available  
        
      s.font(1,1).bold?  
      s.font(1,1).italic?  
      s.font(1,1).underline?

      headers = Hash.new
      s.row(1).each_with_index {|header,i|
        headers[header] = i
      }
      ((s.first_row + 1)..s.last_row).each do |row|
          age = s.row(row)[0]
                    
      end
      @sinfo = s.cell(1,1)
      @sinfo
    end


  end

  class TrainCard < FlashCard
    attr_accessor :title    
    def initialize(*args)
      super(*args)
    end
    
    def fornum=(args)
       @input = args+3
       self.class_eval("def TrainCard.total_time @@total_time = 1;end")      
    end

    def convert answer
      case answer
        when "A" then
          answer='window'
        when "B" then
          answer='path'
        when "C" then
          answer='middle'
        when "window" then
          answer='A'
        when "path" then
          answer='B'
        when "middle" then
          answer='C'
      end
    end
    def train num=5
      window = 'middle'
      if num == 1 || num==184
       window = 'window'
      end
      if num > 115
         num += 1
      end  
      if num > 1 && num < 118
        if (num %5 == 0 || num %5 == 4)
           window = 'window'
         elsif (num %5 == 3 || num %5 == 2)
           window = 'path'
         end
      end
      window
    end   
    
    def self.question
       rand(1-118)
    end

    def TrainCard.create(*args, &block)
       @@inst ||= new(*args, &block) 
    end

    def self.rand_record
      count = Comment.all.count
      Comment.find_by_sql("select * from comments limit " + rand(1-(count-1)).to_s + ", 1")
    end
  
  end

  class FlightCard < FlashCard
        def flight  
          words = { 1 => 'A', 2 => 'B', 3 => 'C', 4 => 'D', 5 => 'E', 6 => 'F', 7 => 'G', 8 => 'H', 9 => 'I'}
          words = [A..Z].take(26)
          sections = Array.new(3)
          sections[0] = [3, 6]
          sections[1] = [4, 5]
          sections[2] = [2, 4]

          edges = Hash.new
          hallways = Hash.new
          surrounds = Hash.new
          k = 0
          for i in 0..(sections.length - 1)   
             for j in 0..(sections[i][0] - 1) 
               for m  in 0..(sections[i][1] - 1)
                 if (j==0 && i==0) || (j==sections[i][0]-1 && i==sections.length-1) 
                   edges[edges.length] = words[k+j+1] + (m + 1).to_s 
                   if(sections[i][0] == 1)
                      hallways[hallways.length] = words[k+j+1] + (m + 1).to_s
                   end          
                 elsif 0< j && j < sections[i][0] - 1
                   surrounds[surrounds.length] = words[k+j+1] + (m + 1).to_s
                 else
                    hallways[hallways.length] = words[k+j+1] + (m + 1).to_s
                 end 
               end
             end
             k = k + sections[i][0]
          end
        end

  end



  class Table < ActiveRecord::Migration

    def self.create_import_template
      # create an xls workbook template for data importing based on models in activerecord
      @format = Spreadsheet::Format.new(:weight => :bold)
      @template_folder = File.join(Rails.root, 'public')
      @template_file = File.join(@template_folder, "data_import_template_#{Time.now.round(3).to_s.chomp(' -0700').gsub(':','-').gsub(' ','_').chop.chop.chop}.xls")
      @book = Spreadsheet::Workbook.new
      debugger
      write_sheet = @book.create_worksheet
      write_sheet.row(0).push "column"
      #add_worksheet_to_template("name")
      #ActiveRecord::Base.send(:subclasses).each {|model| add_worksheet_to_template(model)}
      @book.write @template_file
    end

    def self.add_worksheet_to_template(model)
      # create a tab for each model that you wish to import data into
      write_sheet = @book.create_worksheet :name => model
      write_sheet.row(0).set_format(0, @format)
      model.columns.each_with_index do |c,i|  
        column = ""
        column << "*" unless c.null # indicate required field 
        column << c.name
        write_sheet.row(0).set_format(i+1, @format)
        write_sheet.row(0).push column
      end
    end
  end
end
