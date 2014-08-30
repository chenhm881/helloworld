# encoding: UTF-8
require "roo"

module ExcelHelper

   class Business
     def initialize(*args, &block)
       
     end

     def self.excel_new(file_path = "translation.xls")
      file_path = File.join(Rails.root, "public", file_path)
      workbook = Excel.new(file_path)
      workbook.sheets.each do | sheet |
        workbook.default_sheet = sheet
        break if workbook.to_s == "nil"
        headers = Hash.new
        workbook.row(1).each_with_index do |header, i|
            head_lam = lambda { |headers| 
              return headers 
            }
            headers = create_header_try(headers, workbook.row(1), &head_lam)
            headers = headers_comfirm (headers)
            headers = create_header_try_again(headers, workbook.row(2), &head_lam) if headers.length <= 0
        end
        import_data(headers, workbook) 
      end
 

     end

     def self.import_data(headers, workbook) 
       (workbook.first_row + 1).upto(workbook.last_row).each do |row|
         debugger
         new_row = {english: workbook.row(row)[headers["英文"]], chinese: workbook.row(row)[headers["中文"]]}
         dictionaries = Dictionaries.new(new_row)
         dictionaries.save              
      end
     end  

     def self.create_header_try(*args, &block)
       headers = args[0]
       workrow = args[1]
       hashWorlds = HashWords()
       workrow.each_with_index do |header, i|          
        hashWorlds[:英文].each do |word|
          if header.downcase().include? word
            headers["英文"] = i
          end
        end
        hashWorlds[:中文].each do |word|
          if header.downcase().include? word
            headers["中文"] = i
          end
        end
       end
       p = block.call(headers)
     end
     
     def self.HashWords
       hash = Hash.new { |hash, key| hash[key] = []   }
       hash[:英文] = ["英", "english"]
       hash[:中文] = ["中", "汉", "chinese"]
       hash
     end

     def self.create_header_try_again(*args, &block)
       headers = args[0]
       workrow = args[1]
       index i = 0
       index
       workrow.each_with_index do |text, i|
         if text.strip.length > 1
          if headers[["英文"]] < i
            headers["英文"] = i
          else
            headers["中文"] = i
            break
          end
         end         
       end
       p = block.call(headers)
     end

     def self.headers_comfirm headers
      if headers.length >= 1
       unless headers.length >= 2
          headers["中文"] = (headers.has_key? "英文" && headers["英文"] == 0)? 1 : 0
          headers["英文"] = (headers.has_key? "中文" && headers["中文"] == 1)? 0 : 1 
       end
      end
      headers
     end

          
  end
end