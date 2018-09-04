require_relative 'questions.rb'
require_relative 'users.rb'

class QuestionFollows
  attr_accessor :user_id, :question_id
  
  def self.find_by_user_id(user_id)
    data = QuestionDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        *
      FROM 
        question_follows
      WHERE
        question_follows.user_id = ?
    SQL
    data.map { |datum| QuestionFollows.new(datum) }
  end
  
  def self.find_by_question_id(question_id)
    data = QuestionDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        *
      FROM 
        question_follows
      WHERE
        question_follows.question_id = ?
    SQL
    data.map { |datum| QuestionFollows.new(datum) }
  end
  
  def self.follows_for_question_id(question_id)
    data = QuestionDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        fname, lname, id
      FROM 
        users
      JOIN
        question_follows 
        ON 
          users.id = question_follows.user_id 
      WHERE
        question_follows.question_id = ?
    SQL
    data.map {|datum| User.new(datum) }
  end 
  
  def self.followed_questions_for_user_id(user_id)
    data = QuestionDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        id, title, body, questions.user_id
      FROM 
        questions
      JOIN
        question_follows 
        ON 
          questions.id = question_follows.question_id 
      WHERE
        question_follows.user_id = ?
    SQL
    data.map {|datum| Question.new(datum) }
  end 
  
  def self.most_followed_questions(n)
    data = QuestionDatabase.instance.execute(<<-SQL, n)
      SELECT
        questions.title, questions.id, questions.body, questions.user_id
      FROM 
        questions
      JOIN
        question_follows 
        ON 
          questions.id = question_follows.question_id 
      GROUP BY
        questions.id
      ORDER BY
        COUNT(*) DESC
      LIMIT
        ?
    SQL
    data.map {|datum| Question.new(datum) }
  end
  
  def initialize(options)
    @user_id = options['user_id']
    @question_id = options['question_id']
  end
end 