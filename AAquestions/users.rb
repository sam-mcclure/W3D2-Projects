require_relative 'questions.rb'
require_relative 'replies.rb'
require_relative 'questionfollows.rb'

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
end 