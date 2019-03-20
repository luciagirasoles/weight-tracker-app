require 'json'
require_relative 'Measure.rb'

class User
  
  @@file = 'data.json'

  attr_accessor :email, :name, :gender, :set_milestone, :measures
  
  def initialize(email, name, gender, set_milestone, measures)
    @email = email
    @name = name
    @gender = gender
    @set_milestone= set_milestone
    @measures = measures || []
  end

  def self.read
    JSON.parse(File.read(@@file))
  end

  def self.relation(measures)
    measures_orders = measures.sort { |a,b| b["date"] <=> a["date"]}
    measures_orders.map do |measures|
      Measure.new(measures)
    end
  end

  def self.all
    users_json = self.read
    users_json.map do |user|
      self.new(
        user["email"], 
        user["name"], 
        user["gender"], 
        user["set_milestone"], 
        self.relation(user["measures"])
      )
    end
  end

  def self.find(email)
    users = self.read
    user = users.detect{ |user| user["email"] ==  email}
    self.new(
      user["email"], 
      user["name"], 
      user["gender"], 
      user["set_milestone"],
      self.relation(user["measures"])
    )
  end

  def self.by_last_week 
    users = self.read
    users.map do |user|
      user.measures
    end
  end
end