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
    @video.name = @video.name + File.extname(video_file.original_filename)
    bucket = $S3.buckets['tubeyou.video']
    obj = bucket.objects.create(@video.name, :file => video_file)
    obj.acl = :public_read
    @video.url = URI::encode(ENV['cf_http_url'] + @video.name)

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
    s3 = $S3
    bucket = s3.buckets['tubeyou.video']
    bucket.objects[@video.name].delete

    @video.destroy
    respond_to do |format|
      format.html { redirect_to videos_url }
      format.json { head :no_content }
    end
  end

  def about
  end

  def rate
    @video = Video.find(params[:video_id])
    if @video.scores_times != 0
      scores = params[:scores].to_f
      @video.scores = 
          (@video.scores*@video.scores_times+scores)/(@video.scores_times+1)
    else
      @video.scores = params[:scores].to_i
    end
    @video.scores = format("%.2f",@video.scores).to_f 
    @video.scores_times += 1

    if @video.save
      render :text => { scores: @video.scores,
                        times: @video.scores_times }.to_json
    end             
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
end
