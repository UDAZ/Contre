# frozen_string_literal: true

class ChangeDatatypeContributionsOfUsers < ActiveRecord::Migration[5.2]
  def change
    change_column :users, :contributions, :integer
  end
end
