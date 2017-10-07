class QsheetsController < ApplicationController
  before_action only: [:show, :edit, :update, :destroy]

  # GET /qsheets
  # GET /qsheets.json
  def index
    if current_user.role == 'Admin'
      @contests = Contest.all
      @divisions = Division.all
    else 
      @@contest_id = Contest.find(Judge.find(current_user.id)).id
      _allDivisions = Division.find_by_contest_id(contest_id)
      _allDivisions.each do |currDiv|
        @qsheets = Qsheet.find_by_division_id(currDiv.id)
      end 
    end 
      
    
    # @currIndex = 0
  end

  # GET /qsheets/1
  # GET /qsheets/1.json
  def show
    @division = Division.find(params[:id])
    asks = Ask.where(
      :contest  => @division[:contest],
      :year     => @division[:year],
      :division => @division[:division],
      :round    => @division[:round])
      
    @rubrics = []
    asks.each do |ask|
      @rubrics << Rubric.where(:question => ask[:question])[0]
    end
    
    @qsheet = Qsheet.find_by(:id => params[:id])
    if @qsheet == nil
      @qsheet = Qsheet.new
      @qsheet.division_id = @division.id
      @qsheet.save!
    else
      @qsheet.division_id = @division.id
    end
  end

  # GET /qsheets/new
  def new
    @contest = Contest.find(params[:id])
    #@qsheet = Qsheet.new
    #2.times { @qsheet.questions.build }
  end

  # GET /qsheets/1/edit
  def edit
    puts "entered edit, id = " + params[:id]
    @division = Division.find_by(:id => params[:id])
    @ask = Ask.new
    @rubric = Rubric.new
    @qsheet = Qsheet.find_by(:id => params[:id])
    if @qsheet == nil
      @qsheet = Qsheet.new
      @qsheet.id = @division.id
      @qsheet.save!
    end
  end

  # POST /qsheets
  # POST /qsheets.json
  def create
    #division = Division.find(params[:id])
    #puts "dataType: " + params[:qsheet][:questions_attributes][0][:dataType]
=begin 
    rubric = Rubric.new(rubric_params)
    respond_to do |format|
      if rubric.save
        format.html { redirect_to @qsheet, notice: 'Qsheet was successfully created.' }
        format.json { render :show, id: @qsheet.id, status: :created, location: @qsheet }
      else
        format.html { render :new }
        format.json { render json: @qsheet.errors, status: :unprocessable_entity }
      end
    end
=end
  end
  
  
  
  
  
  # PATCH/PUT /qsheets/1
  # PATCH/PUT /qsheets/1.json
  def update
    respond_to do |format|

    id = params[:id]
    qs = params[:qsheet][:questions_attributes]
    
    qs.each do |q|
      question = q[1][:content]
      type = q[1][:dataType]
      
      puts "update new question"
      puts "id : " + id
      puts "qestion : " + question
      
      rubrics = Rubric.where(:question => question)
      if rubrics.size == 0
        r = Rubric.new(:question => question, :qType => type)
        r.save!
      else
        type = rubrics[0][:qType]  # workaround
      end
      
        division = Division.find(id)
        ask = Ask.new(
          :contest  => division[:contest],
          :year     => division[:year],
          :division => division[:division],
          :round    => division[:round],
          :question => question)
        ask.save!
        
        ps = Participate.where(
          :contest  => division[:contest],
          :year     => division[:year],
          :division => division[:division],
          :round    => division[:round])
          
        judges = []
        contestants = []
        
        ps.each do |p|
          u = User.where(:email => p[:user])[0]
          if u.role == "Judge"
            judges << p
          elsif u.role == "Contestant"
             contestants << p
          end # end if
        end # ps
        
        judges.each do |j|
          contestants.each do |c|
            ass = Assess.new(
              :judge      => j[:user],
              :contestant => c[:user],
              :contest    => division[:contest],
              :year       => division[:year],
              :division   => division[:division],
              :round      => division[:round],
              :question   => question,
              :score      => "empty")
              ass.save!
          end # contestants
        end # judges
      end # qs
    
      @qsheet = Qsheet.find_by(:id => id)
      if @qsheet == nil
        @qsheet = Qsheet.new
        @qsheet.id = id
        @qsheet.save!
      end # end if
      
      format.html { redirect_to @qsheet, notice: 'Qsheet was successfully updated.' }
      format.json { render :show, status: :ok, location: @qsheet }
    end # respons do
  end

  # DELETE /qsheets/1
  # DELETE /qsheets/1.json
  def destroy
    ask = Ask.find(params[:id])
    
    assesses = Assess.where(
      :contest  => ask[:contest],
      :year     => ask[:year],
      :division => ask[:division],
      :round    => ask[:round],
      :question => ask[:question])
      
    assesses.each do |ass| ass.destroy end
    
    # delete ask
    ask.destroy  
    
    respond_to do |format|
      format.html { redirect_to :back, notice: 'Rubric was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def rubric_params
      #params.require(:qsheet).permit(:contest, :questions_attributes => [:id, :content, :dataType])
      params.require(:rubric).permit(:contest, :questions_attributes => [:id, :question, :qType])
    end

    def save_questions(qs, division_id)
      if qs == nil
        return false
      end
      qs.each do |q|
        if q[1][:dataType] == "I" || q[1][:dataType] == "S"
          question = Question.new
          question.dataType = q[1][:dataType]
          question.content = q[1][:content]
          question.qsheet_id= Qsheet.find_by(:division_id => division_id).id
          if !question.save()
            return false
          end
  
          Auctioneer.where(:division_id => division_id).each do |auc|
            score = Scoresheet.new
            score.auctioneer_id = auc.id
            score.question_id = question.id
            score.judge_id = auc.judge_id
            score.score = "empty"
            if !score.save()
              return false
            end
          end
        end
      end
      return true
    end
end
