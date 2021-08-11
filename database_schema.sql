-- CREATE DATABASE
CREATE DATABASE social_media_db;

-- CREATE TABLE 1: USERS
CREATE TABLE users (
    id INT NOT NULL AUTO_INCREMENT,
    username VARCHAR(30) NOT NULL,
    email VARCHAR(40) NOT NULL,
    bio_description VARCHAR(150) NOT NULL,

    PRIMARY KEY(id)
);

-- CREATE TABLE 2: POSTS
CREATE TABLE posts(
    id INT NOT NULL AUTO_INCREMENT,
    user_id INT NOT NULL,
    words VARCHAR(1000) NOT NULL,
    attachment TEXT,
    hashtags VARCHAR(100),
    timepost DATETIME NOT NULL,
    
    PRIMARY KEY(id),
    FOREIGN KEY(user_id) REFERENCES users(id)
);

-- CREATE TABLE 3: COMMENTS
CREATE TABLE comments (
    id INT NOT NULL AUTO_INCREMENT,
    post_id INT NOT NULL,
    words VARCHAR(1000) NOT NULL,
    hashtags VARCHAR(100),
    attachment TEXT,    

    FOREIGN KEY(post_id) REFERENCES posts(id),
    PRIMARY KEY(id)
);
