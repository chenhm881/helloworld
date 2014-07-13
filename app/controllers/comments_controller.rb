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
    @vocalularycard = CommentHelper::VocabularyCard.new(44, 2, 1, 2,lambda{|value='here'| puts value})
    @comment = @vocalularycard.rand_record
    @question = @comment.content
  end

  def answer
    comment = Comment.find(params[:id])
    @answer = comment.answer
    @vocalularycard = CommentHelper::VocabularyCard.new(44, 2, 1, 2,lambda{|value='here'| puts value})
    @comment = @vocalularycard.rand_record
    @question = @comment.content
    @window = @answer
    respond_to do |format|
      format.html {render @comment}
      format.js { render 'comments/answer'}
    end
  end

  def answer_backup
    @comment = Comment.find(params[:id])
    num = params[:question].to_i
    answer = params[:answer].strip
    flashcard = CommentHelper::TrainCard.new(num, 2, 1, 2,lambda{|value='here'| puts value})
    #flashcard.events.fire_on_method(:b=.to_sym, :injected)
    #flashcard.events.listen(:injected) do |event_data| puts "b is now " + event_data.to_s end    
    window = flashcard.train num
    ans = flashcard.convert answer
    if ans==window
      @window = 'Your answer is ' + ans +', correct, congrat'
    else
      @window = 'Your answer is ' + ans +', but the correct is ' + window  
    end
    @question = CommentHelper::TrainCard.question
    @randomrecord = CommentHelper::TrainCard.randrecord 
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
