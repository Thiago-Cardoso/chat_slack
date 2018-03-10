require 'rails_helper'

RSpec.describe TeamsController, type: :controller do
    #using for set header devise
    include Devise::Test::ControllerHelpers #include test for devise with helper of devise

    before(:each) do
        #mapping of devise
        @request.env["devise.mapping"] = Devise.mappings[:user]
        #create a user randon using FactoryBot
        @current_user = FactoryBot.create(:user)
        sign_in @current_user #logged in user
    end

    describe "GET #index" do
        #if result for sucess(200) it is ok
        it "returns http success" do
            get :index
            expect(response).to have_http_status(:success)
        end
    end

    #show the page with last message and channels
    #context is used for return more one diferent situations
    describe "GET #show" do
    
    #the team that try enter in page exists?
    context "team exists" do   
        context "User is the owner of the team" do
            it "Returns success" do
              team = create(:team, user: @current_user)
              get :show, params: {slug: team.slug}

              expect(response).to have_http_status(:success)
            end
        end

    context "User is member of the team" do
        it "Returns success" do
            team = create(:team)
            team.users << @current_user
            get :show, params: {slug: team.slug}

            expect(response).to have_http_status(:success)
        end
    end

    context "User is not the owner or member of the team" do
        it "Redirects to root" do
          team = create(:team)
          get :show, params: {slug: team.slug}

          expect(response).to redirect_to('/')
        end
      end
    end

     #the team enter in page and not exist
    context "team don't exists" do
        it "Redirects to root" do
          team_attributes = attributes_for(:team)
          get :show, params: {slug: team_attributes[:slug] }

          expect(response).to redirect_to('/')
        end
       end
   end

   describe "POST #create" do
    #running before just in describe create
    before(:each) do
      #attributer_for - Generate a model and get attributes and passed user logged
      @team_attributes = attributes_for(:team, user: @current_user)
      post :create, params: {team: @team_attributes}
    end

    #after the create a new team redirect for page team
    it "Redirect to new team" do
        #302 - is status of redirect
      expect(response).to have_http_status(302)
      expect(response).to redirect_to("/#{@team_attributes[:slug]}")
    end

    #check if team is create with atributes right
    it "Create team with right attributes" do
      expect(Team.last.user).to eql(@current_user)
      expect(Team.last.slug).to eql(@team_attributes[:slug])
    end
  end

    describe "DELETE #destroy" do
        before(:each) do
        #delete in format json
        request.env["HTTP_ACCEPT"] = 'application/json'
        end

        #user is team owner
        context "User is the Team Owner" do
        it "returns http success" do
            team = create(:team, user: @current_user)
            delete :destroy, params: {id: team.id}
            expect(response).to have_http_status(:success)
        end
        end

        context "User isn't the team Owner" do
        it "returns http forbidden" do
            team = create(:team)
            delete :destroy, params: {id: team.id}
            expect(response).to have_http_status(:forbidden)
        end
        end

        #someone person not can delete a team
        context "User is member of the team" do
        it "returns http forbidden" do
            team = create(:team)
            team.users << @current_user
            delete :destroy, params: {id: team.id}
            expect(response).to have_http_status(:forbidden)
        end
        end
    end

end