class Chat < ActiveRecord::Base
  validates_presence_of :name

  def self.since(last_id)
    order('id ASC').where('id > ?', last_id)
  end

  def self.recent(limit = 10)
    order('id ASC').limit(limit)
  end
end
