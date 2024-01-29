# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Task, type: :model do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:description) }
  it { should define_enum_for(:status).with_values(Task.statuses.keys) }
  it { should belong_to(:project) }
end
