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
