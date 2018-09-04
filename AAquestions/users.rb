require_relative 'questions.rb'
require_relative 'replies.rb'
require_relative 'questionfollows.rb'
require_relative 'question_like.rb'

class User
  attr_accessor :fname, :lname
  
  def self.find_by_id(id)
    data = QuestionDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM 
        users
      WHERE
        users.id = ?
    SQL
    data.map {|datum| User.new(datum) }
  end
  
  def self.find_by_name(fname, lname)
    data = QuestionDatabase.instance.execute(<<-SQL, fname, lname)
      SELECT
        *
      FROM 
        users
      WHERE
        users.fname = ? AND
        users.lname = ?
    SQL
    data.map {|datum| User.new(datum) }
  end 
  
  def initialize(options)
    @id = options['id']
    @fname = options['fname']
    @lname = options['lname']
  end
  
  def authored_questions
    Question.find_by_user_id(@id)
  end
  
  def authored_replies
    Reply.find_by_user_id(@id)
  end
  
  def followed_questions
    QuestionFollows.followed_questions_for_user_id(@id)
  end
  
  def liked_questions
    QuestionLike.liked_questions_for_user_id(@id)
  end
  
  def average_karma_wrong
    likes = self.authored_questions.map { |question| question.num_likes }
    likes.reduce(:+).to_f / likes.length
  end 
  
  def average_karma_right
    questions_and_likes = self.number_of_questions_and_likes[0]
    questions_and_likes['number_of_likes'].to_f / questions_and_likes['number_of_questions']
  end
  
  def number_of_questions_and_likes
    QuestionDatabase.instance.execute(<<-SQL, @id)
      SELECT
        COUNT(DISTINCT(questions.id)) AS number_of_questions, COUNT(question_like.user_id) AS number_of_likes
      FROM 
        questions
        LEFT OUTER JOIN
          question_like
          ON questions.id = question_like.question_id
      WHERE
        questions.user_id = ?
    SQL
  end
end 