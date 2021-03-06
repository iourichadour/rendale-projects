class Migration330 < ActiveRecord::Migration
  def self.up
    create_table :notes do |t|
      t.column :user_id, :integer
    	t.column :description, :text
    	t.column :date, :date
    	t.column :favorite, :integer
    end
    
    create_table :taggings do |t| 
      t.column :taggable_id, :integer 
      t.column :tag_id, :integer 
      t.column :taggable_type, :string 
    end
     
    create_table :tags do |t| 
      t.column :name, :string 
    end
    
    create_table :note_files do |t|
  		t.column :note_id, :integer
  		t.column :filename, :string
  		t.column :systempath, :string
  		t.column :filetype, :string
  	end
  	

    
  end

  def self.down

    drop_table :notes
    drop_table :note_files
    drop_table :taggings
    drop_table :tags

  
  end
  
end
