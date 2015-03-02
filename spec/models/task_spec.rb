require 'rails_helper'

RSpec.describe Task, type: :model do
  it { should validate_presence_of :title }

  it { should belong_to :list }
end
