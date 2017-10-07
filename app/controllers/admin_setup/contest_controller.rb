class AdminSetup::ContestController < ApplicationController
    skip_before_action :require_login

    def new
      # for the new contest and divisions
      @contest = Contest.new 
      @division = Division.new 
     
      # for the current contest and divisions 
      @cList  = []
      division_all = Division.all
      division_all.each do |division|
        users = Participate.where(
          :contest  => division.contest,
          :year     => division.year,
          :division => division.division,
          :round    => division.round
          ).select(:user)
          
          cnt_judge = 0
          cnt_contestants = 0
          users.each do |user|
            u = User.where(:email => user[:user])
            if u[0].role == "Judge" then
              cnt_judge = cnt_judge + 1
            elsif u[0].role == "Contestant" then
              cnt_contestants = cnt_contestants + 1
            end
          end
      
        contest_id = Contest.where(
          :name => division[:contest], :year => division[:year]).select(:id)
          
        data                  = {}
        data[:id]             = contest_id
        data[:division_id]    = division.id
        data[:contest_name]   = division.contest
        data[:year]           = division.year
        data[:division_name]  = division.division
        data[:round]          = division.round
        data[:num_judge]      = cnt_judge
        data[:num_contestant] = cnt_contestants
      
        @cList << data
      end
    end

    def index
      @contests = Contest.all
    end
    
    def create
        
        parser = DivisionParser.new(params[:division][:division])
        if parser.parse_input_string
          #do nothing
        else
          flash[:failure] = "Input Error"
          redirect_to new_admin_setup_contest_path and return
        end
        rounds = parser.rounds
      
        @contest = Contest.new(:name => params[:contest][:name])
        @contest.year = Time.new.year
        if @contest.save
          flash[:success] = 'Successfully added contest'
          rounds.each do |round|
              @division = Division.new(
                :contest  => @contest[:name],
                :year     => @contest[:year],
                :division => round[0],
                :round    => round[1]
                )
              @division.done = "no"
              if @division.save == false
                  flash[:success] = 'Failed to add division'
              end
          end
        else
          flash[:success] = 'Failed to add contest'
        end
        
        
        redirect_to new_admin_setup_contest_path
    end

    def destroy
      division = Division.find params[:division_id]
      
      # delete ask
      asks = Ask.where(
        :contest  => division[:contest],
        :year     => division[:year],
        :division => division[:division],
        :round    => division[:round])
      asks.each do |ask| ask.destroy end
      
      # delete assess
      assesses = Assess.where(
        :contest  => division[:contest],
        :year     => division[:year],
        :division => division[:division],
        :round    => division[:round])
      assesses.each do |ass| ass.destroy end
     
      # delete participate
      participates = Participate.where(
        :contest  => division[:contest],
        :year     => division[:year],
        :division => division[:division],
        :round    => division[:round])
      participates.each do |p| p.destroy end
      
      
      # delete contest if there isn't any division for the contest
      remained = Division.where(
        :contest => division[:contest],
        :year    => division[:year])
        
      if remained.size <= 1 then
        contest = Contest.where(
          :name => division[:contest],
          :year => division[:year])
         
        # contest for this division should be only one 
        contest.each do |c| c.destroy end  
      end
      
      
      # delete division
      division.destroy
        
      flash[:notice] = "Division #{division.contest} deleted"
      redirect_to new_admin_setup_contest_path
    end
  
  private

    def contest_params
        params.require(:contest).permit(:name, :year)
    end
    
    def division_params
        params.require(:division).permit(:division_name)
    end
    
    def user_params
        #params.require(:user).permit(:email, :password, :password_confirmation, :name)
    end

end



class String
  def is_letter?
    self =~ /[[:alpha:]]/
  end
  
  def is_number?
    self =~ /[[:digit:]]/
  end  
end

class DivisionParser
    
    #by no means in its final state, merely dumped into this file
  def initialize(input_string)
    @input_string = input_string
  end
  
  def parse_input_string
    
    if @input_string.is_a? String
      #nothing happens
    else
      return false
    end
    
    if @input_string.count(":") == 0
      return false
    end
    
    num_rounds = 0
    @input_string.each_char do |z|
      if z.is_number?
        num_rounds += z.to_i
      end
    end
    
    i = 0
    j = 0
    parsed_string = String.new
    parsed_number = String.new
    @rounds_array = Array.new(num_rounds){Array.new(2)}
    while @input_string[i] != nil
    
      if @input_string[i].is_letter?
        parsed_string << @input_string[i]
        
      elsif @input_string[i] == ":"
        i += 1
        
        while @input_string[i].is_number?
          parsed_number << @input_string[i]
          
          if @input_string[i+1] == nil
            i += 1
            break
          end
          
          i += 1
        end
        
        if parsed_number == nil
          return false
        end
        
        parsed_number = parsed_number.to_i
        for k in 1..parsed_number
          @rounds_array[j][0] = parsed_string
          @rounds_array[j][1] = k.to_s
          j += 1
        end
        
        if @input_string[i] != "," and @input_string[i] != nil
          return false
        end
        i += 1
        
        parsed_string = String.new
        parsed_number = String.new
        
      elsif @input_string[i] == " "
        if @input_string[i-1] != ","
          parsed_string << @input_string[i]
        end
        
      else
        return false
      end
      
      i += 1
    end
    
    return true
  end
  
  def rounds
    @rounds_array
  end
  
end