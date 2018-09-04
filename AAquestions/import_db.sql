DROP TABLE IF EXISTS questions;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS quesion_follows;
DROP TABLE IF EXISTS replies;
DROP TABLE IF EXISTS question_like;

PRAGMA foreign_keys = ON;

CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname TEXT NOT NULL,
  lname TEXT NOT NULL
);

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title TEXT NOT NULL,
  body TEXT NOT NULL,
  user_id INTEGER NOT NULL,
  
  FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE question_follows (
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,
  
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);

CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  question_id INTEGER NOT NULL,
  parent_id INTEGER, 
  user_id INTEGER NOT NULL,
  body TEXT NOT NULL,
  
  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (parent_id) REFERENCES replies(id),
  FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE question_like (
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,
  
  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (user_id) REFERENCES users(id)
);

INSERT INTO 
  users(fname, lname)
VALUES 
  ('Tim', 'Song'),
  ('Sam', 'McClure'),
  ('Mike', 'Gee');

INSERT INTO 
  questions(title, body, user_id)
VALUES
  ('Question1', 'Lorem ipsum dolor sit amet', 1),
  ('Question2', 'I don''t know', 2),
  ('Question3', 'What don''t I know', 2);

INSERT INTO 
  question_follows(user_id, question_id)
VALUES 
  (1, 1),
  (2, 2),
  (1, 2),
  (2, 1);

INSERT INTO 
  replies(question_id, user_id, body, parent_id)
VALUES 
  (1, 2, 'consectetur adipiscing elit', NULL),
  (1, 1, 'In id scelerisque lectus', 1),
  (2, 1, 'you do know', NULL),
  (2, 2, 'thank you', 3);
  
INSERT INTO 
  question_like(user_id, question_id)
VALUES 
  (1, 1),
  (1, 2),
  (2, 2),
  (3, 2),
  (2, 3),
  (3, 3);
  