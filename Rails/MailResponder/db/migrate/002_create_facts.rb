class CreateFacts < ActiveRecord::Migration
  def self.up
    create_table :facts do |t|
      t.column :user_id, :integer
      t.column :keywords, :string
      t.column :text, :text
    end
  end

  def self.down
    drop_table :facts
  end
end
