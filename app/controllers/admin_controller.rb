class AdminController < ApplicationController
    skip_before_action :require_login

    def index
        
        @summaries = []
        
        Contest.all.each do |contest|
            puts "contest: " + contest[:name]
            sc = []
            sc << {:contest => contest[:name], :year => contest[:year]}
            divs = Division.where(
                :contest => contest[:name],
                :year => contest[:year])
                
            divs.each do |div|
                puts "division: " + div[:division]
                ps = Participate.where(
                    :contest  => div[:contest],
                    :year     => div[:year],
                    :division => div[:division],
                    :round    => div[:round])
                    
                ps.each do |p|
                    sd = {} # keys: division, user, avg
                    puts "participate : " + p[:user]
                    user = User.where(:email => p[:user])[0]
                    if user.role == "Contestant"
                        puts "user: " + user[:name]
                        
                        # compute average score
                        asses = Assess.where(
                            :contestant => p[:user],
                            :contest     => p[:contest],
                            :year        => p[:year],
                            :division    => p[:division],
                            :round       => p[:round])
                           
                        sum = 0
                        cnt = 0
                        asses.each do |ass|
                            r = Rubric.where(:question => ass[:question])[0]
                            if r.qType == "I" and ass.score != "empty"
                                sum = sum + ass.score.to_i
                                cnt = cnt + 1
                            end
                        end
                       
                        sd[:contest] = contest 
                        sd[:division] = div
                        sd[:user] = user
                        if cnt > 0
                            sd[:avg] = sum / cnt
                        elsif 
                            sd[:avg] = 0
                        end
                        sc << sd
                    end
                end
            end
            
            @summaries << sc
        end
    end
    
    def scoreSummary
        user_id = params[:user_id]
        division_id = params[:division_id]
        avg = params[:avg]
        
        @dataRow = 0
        @scoresheetN = 0
        
        user = User.find(user_id)
        div = Division.find(division_id)
        
        @sc = {
            :user => user,
            :division => div,
            :avg => avg
        }
       
        @sj = {}
        
        assess = Assess.where(
            :contestant => user[:email],
            :contest    => div[:contest],
            :year       => div[:year],
            :division   => div[:division],
            :round      => div[:round])
            
        assess.each do |ass|
           
            sa = {:question => ass[:question], :score => ass[:score]}
            if (@sj[ass[:judge]] == nil)
                @sj[ass[:judge]] = []
            end
            @sj[ass[:judge]]  << sa
            
        end
    end
end