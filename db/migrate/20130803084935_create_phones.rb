class CreatePhones < ActiveRecord::Migration
  def change
    create_table :phones do |t|
      t.string :name, null: false
      t.string :number, null: false
    end
    add_index :phones, :name
  end
end
