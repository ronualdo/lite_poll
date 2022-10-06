# frozen_string_literal: true

class CreateOptions < ActiveRecord::Migration[7.0]
  def change
    create_table :options do |t|
      t.string :label
      t.references :poll, null: false, foreign_key: true

      t.timestamps
    end
  end
end
