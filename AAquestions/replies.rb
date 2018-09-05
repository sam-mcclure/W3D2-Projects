require_relative 'questions.rb'
require_relative 'users.rb'

class Reply
  attr_accessor :question_id, :parent_id, :user_id, :body
  
  def self.find_by_id(id)
    data = QuestionDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM 
        replies
      WHERE
        replies.id = ?
    SQL
    data.map {|datum| Reply.new(datum) }
  end
  
  def self.find_by_user_id(user_id)
    data = QuestionDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        *
      FROM 
        replies
      WHERE
        replies.user_id = ?
    SQL
    data.map {|datum| Reply.new(datum) }
  end
  
  def self.find_by_question_id(question_id)
    data = QuestionDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        *
      FROM 
        replies
      WHERE
        replies.question_id = ?
    SQL
    data.map {|datum| Reply.new(datum) }
  end
  
  def self.find_by_parent_id(parent_id)
    data = QuestionDatabase.instance.execute(<<-SQL, parent_id)
      SELECT
        *
      FROM 
        replies
      WHERE
        replies.parent_id = ?
    SQL
    data.map {|datum| Reply.new(datum) }
  end
  
  def initialize(options)
    @id = options['id']
    @question_id = options['question_id']
    @parent_id = options['parent_id']
    @user_id = options['user_id']
    @body = options['body']
  end
  
  def save 
    if @id.nil?
      QuestionDatabase.instance.execute(<<-SQL, @question_id, @parent_id, @user_id, @body)
        INSERT INTO 
          replies(question_id, parent_id, user_id, body)
        VALUES
          (?, ?, ?, ?)
      SQL
      @id = QuestionDatabase.instance.last_insert_row_id
    else 
      QuestionDatabase.instance.execute(<<-SQL, @question_id, @parent_id, @user_id, @body, @id)
        UPDATE 
          replies
        SET
          question_id = ?, parent_id = ?, user_id = ?, body = ?
        WHERE 
          id = ?
      SQL
    end  
  end
  
  def author 
    User.find_by_id(@user_id)
  end 
  
  def question 
    Question.find_by_id(@question_id)
  end 
  
  def parent_reply
    Reply.find_by_id(@parent_id)
  end 
  
  def child_replies 
    Reply.find_by_parent_id(@id)
  end
end 