class TeamsController < ApplicationController
  before_action :set_team, only: [:destroy]
  before_action :set_by_slug_team, only: [:show]

  #list all teams of user logged
  def index
    @teams = current_user.teams
  end

  #verificate if user logged team have permit for read in record @team
  def show
    authorize! :read, @team
  end

  #create a team with slug and user is logged
  def create
    @team = Team.new(team_params)

    respond_to do |format|
      if @team.save
        format.html { redirect_to "/#{@team.slug}" }
      else
        format.html { redirect_to main_app.root_url, notice: @team.errors }
      end
    end
  end

  #test with can can user can destroy record of team (owner)
  def destroy
    authorize! :destroy, @team
    @team.destroy

    respond_to do |format|
      format.json { head :no_content }
      #format.html { redirect_to main_app.root_url, notice: 'Team deleted' }
    end
  end

  private

  #search for slug
  def set_by_slug_team
    @team = Team.find_by(slug: params[:slug])
  end

  #set team for id
  def set_team
    @team = Team.find(params[:id])
  end

  #params permit
  def team_params
    params.require(:team).permit(:slug).merge(user: current_user)
  end

end
