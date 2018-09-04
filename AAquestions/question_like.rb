require_relative 'questions.rb'

class QuestionLike
  attr_accessor :question_id, :user_id
  
  def self.find_by_user_id(user_id)
    data = QuestionDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        *
      FROM 
        question_like
      WHERE
        question_like.user_id = ?
    SQL
    data.map {|datum| QuestionLike.new(datum) }
  end
  
  def self.likers_for_question_id(question_id)
    data = QuestionDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        *
      FROM 
        question_like
      WHERE
        question_like.question_id = ?
    SQL
    data.map {|datum| QuestionLike.new(datum) }
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