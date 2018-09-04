require_relative 'questions.rb'

class QuestionLike
  attr_accessor :question_id, :user_id
  
  def self.liked_questions_for_user_id(user_id)
    data = QuestionDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        questions.id, questions.body, questions.title, questions.user_id
      FROM 
        question_like
      JOIN 
        questions 
        ON 
        questions.id = question_like.question_id
      WHERE
        question_like.user_id = ?
    SQL
    data.map {|datum| Question.new(datum) }
  end
  
  def self.most_liked_questions(n)
    data = QuestionDatabase.instance.execute(<<-SQL, n)
      SELECT
        questions.title, questions.id, questions.body, questions.user_id
      FROM 
        questions
      JOIN
        question_like
        ON 
          questions.id = question_like.question_id 
      GROUP BY
        questions.id
      ORDER BY
        COUNT(*) DESC
      LIMIT
        ?
    SQL
    data.map {|datum| Question.new(datum) }
  end
  
  def self.likers_for_question_id(question_id)
    data = QuestionDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        users.id, users.fname, users.lname
      FROM 
        question_like
      JOIN
        users
        ON
        users.id = question_like.user_id
      WHERE
        question_like.question_id = ?
    SQL
    data.map {|datum| User.new(datum) }
  end
  
  def self.num_likes_for_question_id(question_id)
    data = QuestionDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        COUNT(*) AS total
      FROM 
        question_like
      WHERE
        question_like.question_id = ?
    SQL
    data[0]['total']
  end 
  
  def initialize(options)
    @question_id = options['question_id']
    @user_id = options['user_id']
  end
end 