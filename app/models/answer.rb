class Answer < ActiveRecord::Base
  acts_as_voteable
  attr_accessible :content, :score, :validated, :question_id
  belongs_to :question
  belongs_to :user
end
