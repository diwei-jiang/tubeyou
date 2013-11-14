class VideosController < ApplicationController
  before_action :set_video, only: [:show, :edit, :update, :destroy]

  # GET /videos
  # GET /videos.json
  def index
    @videos = Video.all
  end

  # GET /videos/1
  # GET /videos/1.json
  def show
  end

  # GET /videos/new
  def new
    @video = Video.new
  end

  # GET /videos/1/edit
  def edit
  end

  # POST /videos
  # POST /videos.json
  def create
    @video = Video.new(video_params)

    video_file = params[:video][:video_file]
    s3 = aws_s3
    bucket = s3.buckets['tubeyou.video']
    obj = bucket.objects.create(@video.name, :file => video_file)
    @video.url = obj.url_for(:read, :secure => false).to_s

    respond_to do |format|
      if @video.save
        format.html { redirect_to @video, notice: 'Video was successfully created.' }
        format.json { render action: 'show', status: :created, location: @video }
      else
        format.html { render action: 'new' }
        format.json { render json: @video.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /videos/1
  # PATCH/PUT /videos/1.json
  def update
    respond_to do |format|
      if @video.update(video_params)
        format.html { redirect_to @video, notice: 'Video was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @video.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /videos/1
  # DELETE /videos/1.json
  def destroy
    @video.destroy
    respond_to do |format|
      format.html { redirect_to videos_url }
      format.json { head :no_content }
    end
  end

  def about
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_video
      @video = Video.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def video_params
      params.require(:video).permit(:name, :description, :url, :scores)
    end

  # aws function
  def aws_cloud_front
    AWS::CloudFront.new(
      :access_key_id => 'AKIAI5APD3BV3SUMCG7Q',
      :secret_access_key => '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',
      :region => "us-east-1")
  end

  def aws_s3
    AWS::S3.new(
      :access_key_id => 'AKIAI5APD3BV3SUMCG7Q',
      :secret_access_key => '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',
      :region => "us-east-1")
  end
end
