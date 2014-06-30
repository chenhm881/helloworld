class ArticlesController < ApplicationController
  # GET /articles
  # GET /articles.json
  def index
    @articles = Article.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @articles }
    end
  end

  def search
     @text_search = params[:title]
     @articles = Article.find_by_sql ["SELECT * FROM articles WHERE title like :title or content like :title", { :title => '%'+@text_search+'%' }]
     
     respond_to do |format|
       format.html #index.html.erb
       format.html{ render 'articles/index', :articles => @articles }
       format.js { render 'articles/search'}
       format.json { render json: @articles }
    end
  end
  
  # GET /articles/1
  # GET /articles/1.json
  def show
    @article = Article.find(params[:id])
    @comments = @article.comments
    @comment = @article.comments.new
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @article; @comment }
    end
  end

  # GET /articles/new
  # GET /articles/new.json
  def new
    @article = Article.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @article }
    end

  end

  # GET /articles/1/edit
  def edit
    @article = Article.find(params[:id])
  end

  # POST /articles
  # POST /articles.json
  def create
    @article = Article.new(params[:article])

    respond_to do |format|
      if @article.save
        format.html { redirect_to @article, notice: 'Article was successfully created.' }
        format.js
        #format.json { render json: @article, status: :created, location: @article }

      else
        format.html { render action: "new" }
        format.js
        #format.json { render json: @article.errors, status: :unprocessable_entity }

      end
    end
  end

  # PUT /articles/1
  # PUT /articles/1.json
  def update
    @article = Article.find(params[:id])

    respond_to do |format|
      if @article.update_attributes(params[:article])
        format.html { redirect_to @article, notice: 'Article was successfully updated.' }
        format.js
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.js
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /articles/1
  # DELETE /articles/1.json
  def destroy
    @article = Article.find(params[:id])
    @article.destroy

    respond_to do |format|
      format.html { redirect_to articles_url }
      format.json { head :no_content }
    end
  end
end
