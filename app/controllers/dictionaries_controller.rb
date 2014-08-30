class DictionariesController < ApplicationController
  def new
    @dictionaries = Dictionaries.new
    respond_to do |format|
      format.html # dictionaries.html.erb
      format.json { render json: @dictionaries }
    end
  end

  def create
     file = params[:dictionaries]
     if !file.original_filename.empty?  
       @filename=file.original_filename   
       File.open("#{Rails.root}/public/#{@filename}", "wb") do |f|  
         f.write(file.read)  
       end  
       ExcelHelper.Buisness.excel_new(@filename)  
     end  
  end

  def flashcard
    @dictionaries = Dictionaries.new
    respond_to do |format|
      format.html # dictionaries.html.erb
      format.json { render json: @dictionaries }
    end
  end

  def answer
    count = Dictionaries.all.count
    return_records = Dictionaries.find_by_sql("select * from dictionaries limit " + rand(1-(count-1)).to_s + ", 1")
    @flashcard = return_records[0]
    respond_to do |format|
      format.html
      format.js {}
    end
  end
end
