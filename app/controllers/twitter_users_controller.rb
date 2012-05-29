class TwitterUsersController < ApplicationController
  # GET /twitter_users
  # GET /twitter_users.json
  def index
    @twitter_users = TwitterUser.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @twitter_users }
    end
  end

  # GET /twitter_users/1
  # GET /twitter_users/1.json
  def show
    @twitter_user = TwitterUser.find(params[:id])
    @follower_ids = Twitter.follower_ids(@twitter_user.twitter_username).collection

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @twitter_user }
    end
  end

  # GET /twitter_users/new
  # GET /twitter_users/new.json
  def new
    @twitter_user = TwitterUser.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @twitter_user }
    end
  end

  # GET /twitter_users/1/edit
  def edit
    @twitter_user = TwitterUser.find(params[:id])
  end

  # POST /twitter_users
  # POST /twitter_users.json
  def create
    @twitter_user = TwitterUser.new(params[:twitter_user])

    respond_to do |format|
      if @twitter_user.save
        format.html { redirect_to @twitter_user, notice: 'Twitter user was successfully created.' }
        format.json { render json: @twitter_user, status: :created, location: @twitter_user }
      else
        format.html { render action: "new" }
        format.json { render json: @twitter_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /twitter_users/1
  # PUT /twitter_users/1.json
  def update
    @twitter_user = TwitterUser.find(params[:id])

    respond_to do |format|
      if @twitter_user.update_attributes(params[:twitter_user])
        format.html { redirect_to @twitter_user, notice: 'Twitter user was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @twitter_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /twitter_users/1
  # DELETE /twitter_users/1.json
  def destroy
    @twitter_user = TwitterUser.find(params[:id])
    @twitter_user.destroy

    respond_to do |format|
      format.html { redirect_to twitter_users_url }
      format.json { head :ok }
    end
  end

  # GET /twitter_users/1/refresh_from_twitter
  def refresh_from_twitter
    @twitter_user = TwitterUser.find(params[:id])
    info_from_twitter = Twitter.user(@twitter_user.twitter_uid.to_i)
    attr = {
      :followers_count   => info_from_twitter.followers_count,
      :favorites_count   => info_from_twitter.favourites_count,
      :friends_count     => info_from_twitter.friends_count,
      :avatar_url        => info_from_twitter.profile_image_url,
      :statuses_count    => info_from_twitter.statuses_count
    }
    respond_to do |format|
      if @twitter_user.update_attributes(attr)
        format.html { redirect_to @twitter_user, notice: 'Twitter user was successfully updated with the latest info from Twitter.' }
        format.json { head :ok }
      else
        format.html { redirect_to @twitter_user, error: 'Unable to update attributes.' }
        format.json { render json: @twitter_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /twitter_users/1/crawl
  def crawl
    @twitter_user = TwitterUser.find(params[:id])
    @favs = @twitter_user.get_favs
    @favs.each do |fav|
      # create the tweet if necessary
      tweet_attr = {
        :twitter_uid => fav.id,
        :text => fav.text,
        :twitter_user_id => @twitter_user.id,
        :timestamp => fav.created_at
      }
      Tweet.create(tweet_attr)

      # create the fav if necessary
      Fav.create(:faver_id => @twitter_user.id, :tweet_id => fav.id)
    end
    respond_to do |format|
      format.html # crawl.html.erb
      format.json { render json: @twitter_users }
    end
  end
end
