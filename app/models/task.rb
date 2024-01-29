# frozen_string_literal: true

class Task < ApplicationRecord
  belongs_to :project
  validates_presence_of :name, :description

  enum :status, %i[new_task in_progress completed], validate: true

  scope :by_status, lambda { |status|
                      status.blank? ? where({}) : where(status:)
                    }
end
