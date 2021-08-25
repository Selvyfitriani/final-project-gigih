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
    user_id INT NOT NULL,
    post_id INT NOT NULL,
    text VARCHAR(1000) NOT NULL,
    hashtags VARCHAR(1000),
    attachment TEXT,    

    PRIMARY KEY(id),
    FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY(post_id) REFERENCES posts(id) ON DELETE CASCADE
);

CREATE TABLE attachments (
    id INT NOT NULL AUTO_INCREMENT, 
    post_id INT,
    comment_id INT,
    filename VARCHAR(200) NOT NULL,
    type VARCHAR(50) NOT NULL,

    PRIMARY KEY(id),
    FOREIGN KEY(post_id) REFERENCES posts(id) ON DELETE CASCADE,
    FOREIGN KEY(comment_id) REFERENCES comments(id) ON DELETE CASCADE
);

-- INSERTING SOME DATA TO DATABASE --
INSERT INTO users(id, username, email, bio_description)
VALUES
    (1, "joko", "joko@gmail.com", "pelajar"),
    (2, "indah", "indah@gmail.com", "selalu tersenyum"),
    (3, "rangga", "rangga31@gmail.com", "orang sibuk"),
    (4, "cika", "cika123@yahoo.com", "a traveller"),
    (5, "selvy", "selvy@gmail.com", "nothing");

INSERT INTO posts(id, user_id, datetime, text, hashtags)
VALUES
    (1, 1, now(), "Aku adalah superhero #gigih", "#gigih "),  
    (2, 2, now(), "Aku adalah superhero #gigih #semangat", "#gigih #semangat "),
    (3, 5, now(), "Aku adalah superhero #semangat", "#semangat "),
    (4, 3, now(), "Aku adalah superhero", ""),
    (5, 4, now(), "Aku adalah superhero #gigih", "#gigih ");

INSERT INTO comments(id, user_id, post_id, text, hashtags)
VALUES
    (1, 5, 1, "Beneran?", ""), 
    (2, 4, 2, "Beneran? #gapercaya", "#gapercaya "), 
    (3, 3, 3, "#Wkwk", "#Wkwk "), 
    (4, 2, 4, "Semangat yaaa", ""), 
    (5, 1, 5, "Masa sih?", "");