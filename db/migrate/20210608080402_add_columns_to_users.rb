# frozen_string_literal: true

class AddColumnsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :name, :string
    add_column :users, :uid, :string
    add_column :users, :provider, :string
    add_column :users, :contributions, :string
    add_column :users, :github_url, :string
    # uidとproviderにインデックスとユニークを付与
    add_index :users, %i[uid provider], unique: true
  end
end
