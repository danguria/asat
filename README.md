# Cource Project #1

- Student Name : Sungkeun Kim

# What the Project does is ...
For this project I have designed a site to assist in managing and judging contestants for any types of a Contest you want to hold. This will be done by allowing an administrator to create questions, add judges, and formulate contestants’ performances based on a tournament-like hierarchal structure. The key component to our project is that the admin has all authority. There is no signup page since the power of making accounts is under the scope of the admin.


# Installation
This project is developped using the _*Ruby on Rails*_ and deployed using the _*Heroku*_. Therefore, you don't need install anything. You can see my project by jusg cliking the link as follow:
- https://db-project1.herokuapp.com


# Login Information
## 1. Admin
You can log in as the admin user so that you create contests, judges, contests, and rubrics.
- ID(email) : admin@gmail.com
- PW        : 123
## 2. Judge
You can log in as a judge so that you assess contestants that you are assigned to a contest. You can see the login information at the *Judge* tap in the admin menu. Twenty judges are created by default and their ID(email) are contest1@gmail.com to contest20@gmail.com. Also their password are "123"


## 3. Contestant
Contestants can not be logged in the site because this site is the assessment system.

# Instructions for Site

## 1. Creating a Contest:
When setting up a new tournament the first step is to create the Contest. Above there is a tab labeled 'Contest', this links to the contest setup page. This page allows for a new contest to be created, or an old contest to be deleted. Enter in the contest name then the division, i.e Contest Name: LoneStar 2017 Divisons: Veteran:3, Rookie:2. will create a Contest of name LoneStar 2017 and 3 Veteran divisions (1,2,3) and 2 Rookie divisions (1,2).

## 2. Creating the Judges:
Now that the contest is created you can add the judges. Start by clicking the Judge tab above. By selecting the contest in the dropdown menu it is possible to change which contest the judge will be added to. It is assumed all judges will score all contestants.If a judge will be scoring another contest in the future it is possible to reassign the current judges to different contests by using the dropdown bar located within the table at the bottom of this page.

## 3. Creating the Contestants:
Now that the judges are created you can start adding Contestants. Start by clicking the Contestant tab above. Fill out the name / email then select the correct division and round. Contestants previously created can also be deleted from the table below.

## 4. Creating the Questions:
To create a new question sheet first select the Questions tab above. The current contests split by their divisions will be listed below. By clicking 'Show' the question sheet for the particular divsion / round is displayed. Here there is the option to delete old questions or create new ones. When creating a question there is field for selecting the type of the question. If the question is meant hold a score from 0-10.0 then the correct type would be 'int'. If the question area is meant to hold comments or categorical data select the 'string' type.
