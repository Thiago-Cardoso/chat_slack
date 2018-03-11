class TeamUsersController < ApplicationController
  before_action :set_team_user, only: [:destroy]

    #create a TeamUser of user logged
  def create
    @team_user = TeamUser.new(team_user_params)

    #verificate if user can create a TeamUser inside teamuser
    authorize! :create, @team_user

    respond_to do |format|
      if @team_user.save
        format.json { head :ok }
      else
        format.json { render json: @team_user.errors, status: :unprocessable_entity }
      end
    end
  end

   #test with can can user can destroy record of teamuser (owner)
  def destroy
    authorize! :destroy, @team_user
    @team_user.destroy

    respond_to do |format|
      format.json { head :no_content }
    end
  end

  private

   #set team for id user and id team
  def set_team_user
    @team_user = TeamUser.find_by(params[:user_id], params[:team_id])
  end

  #params permit
  def team_user_params
    params.require(:team_user).permit(:team_id, :user_id)
  end
end