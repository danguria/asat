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
     :name => 'Lance',
     :role=>"Admin"}, 
    {
     :email => 'judge1@gmail.com',
     :password => '123',
     :bare_password=> '123',
     :name => 'Sungkuen Kim',
     :role=>"Judge"}, 
    {
     :email => 'judge2@gmail.com',
     :password => '123',
     :bare_password=> '123',
     :name => 'Donghwa Shin',
     :role=>"Judge"}, 
    {
     :email => 'contestant1@gmail.com',
     :password => '123',
     :bare_password=> '123',
     :name => 'Aaron',
     :role => "Contestant"}, 
    {
     :email => 'contestant2@gmail.com',
     :password => '123',
     :bare_password=> '123',
     :name => 'Hannah',
     :role =>"Contestant"}, 
    ]

users.each do |user|
    User.create!(user)
end

contests = [
 {
  :name => "Texas Contest 2017",
  :year => 2017
 }
 ]
contests.each do |contest|
     Contest.create!(contest)
end

divisions = []
contests.each do |contest|
 divisions << {
      :contest => contest[:name],
      :year => contest[:year],
      
      :division=> "Rookie",
      :done => "no",
      :round => 1}
 divisions << {
      :contest => contest[:name],
      :year => contest[:year],
      :division => "Ringman",
      :done => "no",
      :round => 1} 
 divisions << {
      :contest => contest[:name],
      :year => contest[:year],
      :division => "Ringman",
      :done => "no",
      :round => 2}
 divisions << {
      :contest => contest[:name],
      :year => contest[:year],
      :division => "Senior",
      :done => "no",
      :round => 1}
 divisions << {
      :contest => contest[:name],
      :year => contest[:year],
      :division => "Senior",
      :done => "no",
      :round => 2}
 divisions << {
      :contest => contest[:name],
      :year => contest[:year],
      :division => "Champion",
      :done => "no",
      :round => 1}
 divisions << {
      :contest => contest[:name],
      :year => contest[:year],
      :division=> "Champion",
      :done => "no",
      :round => 2}
end
 
divisions.each do |division|
   Division.create!(division)
end


# every user participates every division of every contest
participates = []
users.each do |user|
 divisions.each do |division|
  if (user[:role] != "Admin")
   participates << {
    :user => user[:email],
    :contest => division[:contest],
    :year => division[:year],
    :division => division[:division],
    :round => division[:round]}
  end
 end
end

participates.each do |p|
 Participate.create!(p)
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
 
asks = []
divisions.each do |d|
 rubrics.each do |r|
  asks << {
   :contest => d[:contest],
   :year => d[:year],
   :division => d[:division],
   :round => d[:round],
   :question => r[:question]}
 end
end

asks.each do |ask|
 Ask.create!(ask)
end

judges = []
contestants = []

users.each do |u|
 if u[:role] == "Judge"
  judges << u
 elsif u[:role] == "Contestant"
  contestants << u
 end
end

assesses = []
judges.each do |judge|
contestants.each do |contestant|
   asks.each do |ask|
    assesses << {
     :judge => judge[:email],
     :contestant => contestant[:email],
     :contest => ask[:contest],
     :year => ask[:year],
     :division => ask[:division],
     :round => ask[:round],
     :question => ask[:question],
     :score => "empty"
    }

    #puts "adding " + judge[:email]
    #puts contestant[:email]
    #puts d[:contest]
    #puts d[:division]
    #puts d[:round]
  end
 end
end

assesses.each do |ass|
 Assess.create!(ass)
end