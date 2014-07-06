class CommentsController < ApplicationController

  def create
    @article = Article.find(params[:comment][:article_id])
    @comment = @article.comments.new(params[:comment])
    respond_to do |format|
      if @comment.save
        format.html { redirect_to @article, notice: 'comment was successfully created.' }
        format.js
        #format.json { render json: @comment, status: :created, location: @comment }

      else
        format.html { render action: "new" }
        format.js
        #format.json { render json: @comment.errors, status: :unprocessable_entity }

      end
    end
  end

  def show
    @comment=Comment.find(params[:id])
    @answer=5
  end

  def answer
    @comment = Comment.find(params[:id])
    num = params[:answer].to_i
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
       else if (num %5 == 3 || num %5 == 2)
         window = 'path'
       end
      end

    end
    words = { 1 => 'A', 2 => 'B', 3 => 'C', 4 => 'D', 5 => 'E', 6 => 'F', 7 => 'G', 8 => 'H', 9 => 'I'}
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
         else if 0< j && j < sections[i][0] - 1
           surrounds[surrounds.length] = words[k+j+1] + (m + 1).to_s
          else
            hallways[hallways.length] = words[k+j+1] + (m + 1).to_s
          end
         end
        end
       end
       k = k + sections[i][0] 
    end
    debugger 
    @window = window
    respond_to do |format|
      format.html {render @comment}
      format.js { render 'comments/answer'}
    end
  end

  # GET /comment/1/edit
  def edit
    @comment = Comment.find(params[:id])
    @article = Article.find(@comment.article_id)
  end
  
  def update
    @comment = Comment.find(params[:id])
    @article = Article.find(@comment.article_id)
    respond_to do |format|
      if @comment.update_attributes(params[:comment])
        format.html { redirect_to @article, notice: 'Comment was successfully updated.' }
        format.js
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.js
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @comment = Comment.find(params[:id])
    @article = Article.find(@comment.article_id)
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to @article }
      format.json { head :no_content }
    end
  end

end
