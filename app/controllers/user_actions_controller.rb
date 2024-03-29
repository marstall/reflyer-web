class UserActionsController < ApplicationController
  before_action :set_user_action, only: [:show, :edit, :update, :destroy]

  # GET /user_actions
  # GET /user_actions.json
  def index
    @user_actions = UserAction.all
    render json: @user_actions
  end

  # GET /user_actions/1
  # GET /user_actions/1.json
  def show
  end

  # GET /user_actions/new
  def new
    @user_action = UserAction.new
  end

  # GET /user_actions/1/edit
  def edit
  end

  # POST /user_actions
  # POST /user_actions.json
  def create
    @user_action = UserAction.new(user_action_params)

    respond_to do |format|
      if @user_action.save
        format.html { redirect_to @user_action, notice: 'User action was successfully created.' }
        format.json { render :show, status: :created, location: @user_action }
      else
        format.html { render :new }
        format.json { render json: @user_action.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /user_actions/1
  # PATCH/PUT /user_actions/1.json
  def update
    respond_to do |format|
      if @user_action.update(user_action_params)
        format.html { redirect_to @user_action, notice: 'User action was successfully updated.' }
        format.json { render :show, status: :ok, location: @user_action }
      else
        format.html { render :edit }
        format.json { render json: @user_action.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user_actions/1
  # DELETE /user_actions/1.json
  def destroy
    @user_action.destroy
    respond_to do |format|
      format.html { redirect_to user_actions_url, notice: 'User action was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def valid_request?(params) 
    return true
  end
  
  def send_to_top
    id = params[:id]
    raise Exception unless valid_request?(params)

    flyer = Flyer.find(id)
    flyer.last_sent_to_top_at = DateTime.now
    flyer.save

    user_action = UserAction.new
    user_action.action_type='flyer'
    user_action.action_subtype='send_to_top'
    user_action.flyer_id=id
    user_action.description = flyer.title
    user_action.user_id=nil
    user_action.data = request.user_agent
    user_action.save
    flash[:highlighted_flyer_id]=id
    flash[:notice]="You sent '#{flyer.title}' to the top!"
    redirect_to :root
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_action
      @user_action = UserAction.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_action_params
      Rails.logger.info("params: #{params}")
      params.require(:user_action).permit([:description,:action_type,:action_subtype,:flyer_id,:user_id,:data])
    end
end
