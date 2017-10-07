class AdminSetup::JudgeController < ApplicationController
    skip_before_action :require_login

    def new
        
        # for the new judge
        @user = User.new
        @contest = Contest.new
        #@new_judge = Judge.new
      
        # list up the current judges and their contest
        @jList  = []
        users = User.where(role: "Judge")
        users.each do |u|
            # TODO:
            # User can participate more than one contest,
            # but current user interface doesn’t support that
            contest = Participate.where(:user => u[:email]).select(:contest, :year)[0]
            
            mem                 = {}
            mem[:id]            = u[:id]
            mem[:name]          = u[:name]
            mem[:email]         = u[:email]
            mem[:bare_password] = u[:bare_password]
            mem[:contest_name]  = contest[:contest]
            @jList << mem
        end
    end

    def index
        @user = User.new
        @new_judge = Judge.new
        @contest = Contest.new
    end

    def create
        @user = User.new(user_params)
        @user.role = "Judge"
        @user.bare_password = @user.password
        
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
                    if user.role == "Contestant"
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
                            :judge => @user[:email],
                            :contestant => c[:user],
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
        
        redirect_to new_admin_setup_judge_path
    end

    def destroy
        # delete user
        judge = User.find params[:id]
        judge.destroy
        
        # delete participate
        ps = Participate.where(
            :user => judge[:email])
        ps.each do |p| p.destroy end
        
        # delete assess
        asseses = Assess.where(
            :judge => judge[:email])
        asseses.each do |ass| ass.destroy end
        
        flash[:notice] = "Judge #{judge.name} deleted"
        redirect_to new_admin_setup_judge_path
    end
    
    def show
        puts params
        
        
        redirect_to new_admin_setup_judge_path
    end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :name, :bare_password)
  end

end