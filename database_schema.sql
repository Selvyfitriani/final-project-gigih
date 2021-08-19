-- CREATE DATABASE
CREATE DATABASE social_media_db;
USE social_media_db;

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
    text VARCHAR(1000) NOT NULL,
    attachment TEXT,
    hashtags VARCHAR(1000),
    datetime DATETIME NOT NULL,
    
    PRIMARY KEY(id),
    FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- CREATE TABLE 3: COMMENTS
CREATE TABLE comments (
    id INT NOT NULL AUTO_INCREMENT,
    post_id INT NOT NULL,
    text VARCHAR(1000) NOT NULL,
    hashtags VARCHAR(1000),
    attachment TEXT,    

    PRIMARY KEY(id),
    FOREIGN KEY(post_id) REFERENCES posts(id) ON DELETE CASCADE
);
