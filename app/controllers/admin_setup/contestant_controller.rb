class AdminSetup::ContestantController < ApplicationController
    skip_before_action :require_login

    def new
         # for the new contestant
        @user = User.new
        @contest = Contest.new
      
        # list up the current contestant and their contest(division)
        @cList  = []
        users = User.where(role: "Contestant")
        users.each do |u|
            # TODO:
            # User can participate more than one contest,
            # but current user interface doesn’t support that
            pContest = Participate.where(:user => u[:email])[0]
            
            c = Contest.where(
                :name => pContest[:contest],
                :year => pContest[:year])[0]
            mem                 = {}
            mem[:id]            = u[:id]
            mem[:contest_id]    = c[:id]
            mem[:name]          = u[:name]
            mem[:email]         = u[:email]
            mem[:contest_name]  = c[:name]
            @cList << mem
        end
    end

    def index
        @user = User.new
    end
    def create
        # create user
        @user = User.new(user_params)
        @user.password = "contest_default"
        @user.password_confirmation = "contest_default"
        @user.bare_password = "contest_default"
        @user.role= "Contestant"
        
        if @user.save
            flash[:success] = 'Successfully created a Judge'
            contest  = Contest.find(params[:contest][:name])
            divisions = Division.where(
                :contest => contest[:name],
                :year    => contest[:year])
            
            divisions.each do |division|
                # create participate
                p = Participate.new(
                    :user     => @user[:email],
                    :contest  => division[:contest],
                    :year     => division[:year],
                    :division => division[:division],
                    :round    => division[:round])
                p.save
                
                p_contestants = Participate.where(
                    :contest  => division[:contest],
                    :year     => division[:year],
                    :division => division[:division],
                    :round    => division[:round])
                    
                contestants = []
                p_contestants.each do |pc|
                    user = User.where(:email => pc[:user])[0]
                    if user.role == "Judge"
                        contestants << user
                    end
                end
                    
                contestants.each do |c|
                    asks = Ask.where(
                        :contest  => division[:contest],
                        :year     => division[:year],
                        :division => division[:division],
                        :round    => division[:round])
                       
                    # create assess based on ask
                    asks.each do |ask|
                        ass = Assess.new(
                            :judge => c[:user],
                            :contestant => @user[:email],
                            :contest    => ask[:contest],
                            :year       => ask[:year],
                            :division   => ask[:division],
                            :round      => ask[:round],
                            :question   => ask[:question],
                            :score      => "empty")
                        ass.save
                    end
                end
            end
        else
            flash[:success] = 'Failed to created a Judge'
        end 
       
        if @user.save
            flash[:success] = 'Successfully created a Contestant'
        else
            flash[:success] = 'Failed to created a Contestant'
        end
        redirect_to new_admin_setup_contestant_path
    end

    def destroy
       
        # delete user
        contestant = User.find params[:id]
        contestant.destroy
        
        # delete participate
        ps = Participate.where(
            :user => contestant[:email])
        ps.each do |p| p.destroy end
        
        # delete assess
        asseses = Assess.where(
            :contestant => contestant[:email])
        asseses.each do |ass| ass.destroy end
        
        flash[:notice] = "Contestant #{contestant.name} deleted"
        redirect_to new_admin_setup_contestant_path
    end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :name, :bare_password)
  end

end