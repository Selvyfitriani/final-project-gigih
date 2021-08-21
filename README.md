## Final Project - Generasi Gigih Intermediate Class

Name: Selvy Fitriani
Participant ID: GBE01137
Class: BE Bisa

-------

### Problem Description
This API was created to fulfill simple social media needs. There are several functions that needed by the social media, they are:
1. Users can register themselves
2. Users can make post
3. Users can search for posts with certain hashtags
4. Users can search for trending hashtags
5. Users can comment on a post
6. Users can attach files to posts or comments.

### Prerequisites 
To run this application locally on your computer, here are some prerequisites you need:
1. Ruby 2.7 (https://www.ruby-lang.org/en/documentation/installation/)
2. MySQL 8.0 (https://dev.mysql.com/doc/refman/8.0/en/installing.html)
3. Postman (https://www.postman.com/downloads/)

The link suggested above is just for option, you can use your own source to install the prerequisites.

### How to Run

#### Setup the Database
After you install MySQL, you can create database using SQL script in the root of this repository (``database_schema.sql``)

1. Login into your MySQL
`` mysql -u root -p ``
Then, insert your password
2. Run the SQL Script
`` source \path-to-this-repo\final-project-gigih\database-schema.sql``
This script will create the database and insert some dummy data.

#### Install Dependencies
This command will install all dependencies in Gemfile
``bundle install``


#### Run the Test Suite
Point your terminal to this repository root, then simply you can run the command below to run all the test. 
``rspec spec/``
Then, it will create a folder ``coverage`` and you can see the coverage detail in ``coverage\index.html``

#### Run the Application
To run this application, you just need to run this command in this repository root
``ruby main.rb ``

If you done with this step, you can use the application through the Postman. 

#### Using the Existent Postman Collection
You don't need to create your own collection, you can use my collection to test this application. Here are the steps to use it:
1. Open Postman
2. Select "Import"
3. Select "Link"
4. Copy paste the postman collection link: https://www.getpostman.com/collections/0af80940e9ddbba64c0d
5. Click Continue

In that collection, there are 5 request to fulfill problem number 1-5.

If there are any questions, feel free to reach me on selvyfiriani@gmail.com 