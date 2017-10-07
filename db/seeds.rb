# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
users = [
    {
     :email => 'admin@gmail.com',
     :password => '123',
     :bare_password => '123',
     :name => 'Admin',
     :role=>"Admin"}
]

contestants = []
judges = []

(1..20).each do |i|
 c = {
  :email => "contestant" + i.to_s + "@gmail.com",
  :password => "123",
  :bare_password => "123",
  :name => "contestant" + i.to_s,
  :role => "Contestant"
 }
 users << c
 contestants << c
 
 j = {
  :email => "judge" + i.to_s + "@gmail.com",
  :password => "123",
  :bare_password => "123",
  :name => "judge" + i.to_s,
  :role => "Judge"
 }
 
 users << j
 judges << j
end

users.each do |user|
    User.create!(user)
end

rubrics = [
  {
  :question => "[Opening Statement] Contestant Greeting, States Their Name, Contestant Number, and describes the Item for Sale.",
   :qType => "I"
  },
  {
  :question => "[Style] Delivery, Poise, Eye Contact, and Gestures.	",
   :qType => "I"
  },
  {
  :question => "[Overall Bid Calling] Voice control, Voice Clarity, Volume, Speed, Rhythm, Bid Escalation.	",
   :qType => "I"
  },
  {
  :question => "[Professional Image] Appearance, Manner and Attitude.	",
   :qType => "I"
  },
  {
  :question => "[Salesmanship] Encourages the audience to bid, did bid reach a minimum $50.00	",
   :qType => "I"
   },
  {
  :question => "[Professionalism] Overall impression: Do you believe the Contestant fairly represented the merchandise, the auction profession, and would you hire this Contestant to sell your sale.	",
   :qType => "I"
  },
  {
  :question => "Comments",
   :qType => "S"
  }
 ]
  
rubrics.each do |r|
   Rubric.create!(r)
end





(1..4).each do |i|  # contest
 c = {:name => "Contest" + i.to_s, :year => Time.new.year}
 Contest.create!(c)
 
 puts "contest " + i.to_s
 
 (1..4).each do |j|  # division
  puts "division " + j.to_s
  (1..4).each do |k| # round
  
    pcs = []
    pjs = []
    if i == 1
     (0..4).each do |idx|
      puts "add ps " + idx.to_s
      pcs << {:email => contestants[idx][:email] }
      pjs << {:email => judges[idx][:email] }
     end
    elsif i == 2
     (5..9).each do |idx|
      puts "add ps " + idx.to_s
      pcs << {:email => contestants[idx][:email] }
      pjs << {:email => judges[idx][:email] }
     end
    elsif i == 3
     (10..14).each do |idx|
      puts "add ps " + idx.to_s
      pcs << {:email => contestants[idx][:email] }
      pjs << {:email => judges[idx][:email] }
     end
    elsif i == 4
     (15..19).each do |idx|
      puts "add ps " + idx.to_s
      pcs << {:email => contestants[idx][:email] }
      pjs<< {:email => judges[idx][:email] }
     end
    end
  
    d = {:contest => c[:name], :year => c[:year],
    :division => "division" + j.to_s, :round => k, :done => "false"}
    
    Division.create!(d)
    #Qsheet.create!(:division_id => Division.where(d)[0][:id])
    Rubric.all.each do |r|
     Ask.create!(
      :contest => c[:name],
      :year => c[:year],
      :division => d[:division],
      :round => d[:round],
      :question => r[:question])
    end
    
    #(0..9).each do |idx|
    pcs.each do |contestant|
     #puts "idx = " + idx.to_s
     #contestant = pcs[0] #User.where(:email => "contestant" + i.to_s + "@gmail.com")[0] 
     #pcs.delete_at(0)
     pc = { 
      :user => contestant[:email],
      :contest => c[:name],
      :year => c[:year],
      :division => d[:division],
      :round => d[:round]}
      
      if Participate.where(pc).size == 0
       Participate.create!(pc)
      end
     pjs.each do |judge|
     #judge = pjs[0] #User.where(:email => "judge" + i.to_s + "@gmail.com")[0] 
     #pjs.delete_at(0)
     pj = { 
      :user => judge[:email],
      :contest => c[:name],
      :year => c[:year],
      :division => d[:division],
      :round => d[:round]}

      if Participate.where(pj).size == 0
       Participate.create!(pj)
      end
    
     Rubric.all.each do |r|
       
      Assess.create!(
       :judge => pj[:user],
       :contestant => pc[:user],
       :contest => c[:name],
       :year => c[:year],
       :division => d[:division],
       :round => d[:round],
       :question => r[:question],
       :score => "empty")
    end # rubric
   end # pcs
  end # pjs
  end # round
 end # division
end # contest