require 'singleton'
require 'sqlite3'
require_relative 'users.rb'
require_relative 'replies.rb'
require_relative 'questionfollows.rb'
require_relative 'question_like.rb'

class QuestionDatabase < SQLite3::Database
  include Singleton
  
  def initialize
    super('questions.db')
    self.results_as_hash = true 
  end
end

class Question
  attr_accessor :title, :body, :user_id
  
  def self.find_by_id(id)
    data = QuestionDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM 
        questions
      WHERE
        questions.id = ?
    SQL
    data.map {|datum| Question.new(datum) }
  end
  
  def self.find_by_user_id(user_id)
    data = QuestionDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        *
      FROM 
        questions
      WHERE
        questions.user_id = ?
    SQL
    data.map {|datum| Question.new(datum) }
  end
  
  def self.most_followed(n)
    QuestionFollows.most_followed_questions(n)
  end 
  
  def self.most_liked(n)
    QuestionLike.most_liked_questions(n)
  end
  
  def initialize(options)
    @id = options['id']
    @title = options['title']
    @body = options['body']
    @user_id = options['user_id']
  end
  
  def save 
    if @id.nil?
      QuestionDatabase.instance.execute(<<-SQL, @title, @body, @user_id)
        INSERT INTO 
          questions(title, body, user_id)
        VALUES
          (?, ?, ?)
      SQL
      @id = QuestionDatabase.instance.last_insert_row_id
    else 
      QuestionDatabase.instance.execute(<<-SQL, @title, @body, @user_id, @id)
        UPDATE 
          questions
        SET
          title = ?, body = ?, user_id = ?
        WHERE 
          id = ?
      SQL
    end  
  end
  
  def author
    User.find_by_id(@user_id)
  end
  
  def replies
    Reply.find_by_question_id(@id)
  end
  
  def followers
    QuestionFollows.follows_for_question_id(@id)
  end
  
  def likers
    QuestionLike.likers_for_question_id(@id)
  end
  
  def num_likes
    QuestionLike.num_likes_for_question_id(@id)
  end
end 

