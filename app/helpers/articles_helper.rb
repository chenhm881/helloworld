module ArticlesHelper

  #require  File.dirname(__FILE__) + '../common/excel/business'
  require File.expand_path('../../common/excel/business', __FILE__)
  class ControllerTest
    def initialize (*args)
      #ExcelHelper::Business.excel_new
    end
  end
end
