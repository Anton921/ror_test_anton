# frozen_string_literal: true

class Task < ApplicationRecord
  belongs_to :project
  validates_presence_of :name, :description

  enum status: { new_task: 0, in_progress: 1, completed: 2 }

  scope :by_status, lambda { |status|
                      status.blank? ? where({}) : where(status:)
                    }
end
