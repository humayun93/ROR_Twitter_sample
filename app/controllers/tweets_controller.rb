class TweetsController < ApplicationController
 
  before_action :authenticate_user!
  load_and_authorize_resource

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end 
  rescue_from ActiveRecord::RecordNotFound do |exception|
    redirect_to root_url, :alert => "Record Not Found"
  end
  # GET /tweets
  # GET /tweets.json
  
  
  def mytweets
    
     @tweets = Tweet.where user_id: current_user.id
     @tweet=current_user.tweets.new
     @page=2
   end

  def search
   
    @tweets = Tweet.where "content LIKE ?" ,"%#{params[:q]}%"
    @tweets_with_tags= Tweet.tagged_with(["awesome"], :any => true)
    @page=0
  end


  def index
     @tweet = current_user.tweets.new
     @tweets = Tweet.all
     @page=1
  end

  # POST /tweets
  # POST /tweets.json
  def create
 
     @tweet = current_user.tweets.new(tweet_params)
     respond_to do |format|
      if @tweet.save
        format.html { redirect_to tweets_path, notice: t('tweet_success')}
        format.json { render action: 'show', status: :created, location: @tweet }
      else
        format.html { redirect_to tweets_path   }
        format.json { render json: @tweet.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tweets/1
  # PATCH/PUT /tweets/1.json
  def update
    respond_to do |format|
      if @tweet.update(tweet_params)
        format.html { redirect_to tweets_path, notice: t('tweet_update_success')}
        format.json { head :no_content }
      else
        format.html { redirect_to tweets_path }
        format.json { render json: @tweet.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tweets/1
  # DELETE /tweets/1.json
  def destroy
    
    if @tweet.destroy
    respond_to do |format|
    format.html { redirect_to tweets_path ,notice: t('tweet_delete_success')}
    format.json { head :no_content }
      end
    else
    respond_to do |format|
    format.html { redirect_to tweets_path ,alert: t('tweet_delete_failed')}
    format.json { head :no_content }
      end
      
    end

  end

  private
    def tweet_params
      params.require(:tweet).permit(:content, :user_id)
    end
 
end
