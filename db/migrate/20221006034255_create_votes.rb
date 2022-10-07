# frozen_string_literal: true

class CreateVotes < ActiveRecord::Migration[7.0]
  def change
    create_table :votes do |t|
      t.references :option, null: false, foreign_key: true
      t.string :user

      t.timestamps
    end
  end
end
