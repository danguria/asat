class ParticipateController < ApplicationController
    skip_before_action :require_login

    def index
        puts "hi user  #{current_user.id}"
      
        user = User.find(current_user.id) 
        ps = Participate.where(:user => user[:email])
        @contest_info = {}
        
        ps.each do |p| 
            contest = p[:contest] + " " + p[:year].to_s
            if @contest_info[contest] == nil
                @contest_info[contest] = []
            end
            
            @contest_info[contest] << p
        end
    end

    def show
        judge = Participate.find(params[:id])
        
        ps = Participate.where(
            :contest  => judge[:contest],
            :year     => judge[:year],
            :division => judge[:division],
            :round    => judge[:round])
           
        @contest = judge
        @contestants = []
        ps.each do |p|
            u = User.where(:email => p[:user])[0]
            if (u.role == "Contestant")
                @contestants << p
            end
        end
    end

    def edit
        
       @contestant = Participate.find(params[:id])
       @cuser = User.where(:email => @contestant[:user])[0]
       @assess = getAssess(params[:id])
    end

    def update
        
        puts "entered update"
        assess = getAssess(params[:id])
        success = true
        
        (0..(assess.size() -1)).each do |i|
            puts "i: " + i.to_s
            ass = assess[i][0]  # Assess
        
            puts "trying to update " + ass[:id].to_s + "'th assess"   
            puts "score " +  ass[:score] 
            ass[:score] = params['output'][ass[:id].to_s][:score]
            if (!ass.save())
                flash[:warnning] = 'Judging Failed'
                success = false
            end
        end
        
      if success
        flash[:success] = 'Contestant Judged Successfully'
      end

      redirect_to participate_index_path
    end
    
    def getAssess(id)
       contestant = Participate.find(id)
       
       qsheets = Assess.where(
           :judge      => current_user[:email],
           :contestant => contestant[:user],
           :contest    => contestant[:contest],
           :year       => contestant[:year],
           :division   => contestant[:division],
           :round      => contestant[:round])
        
        assess = []  
        qsheets.each do |qs|
            r = Rubric.where(:question => qs[:question])[0]
            assess << [qs, r]
        end
        
        return assess
    end
end