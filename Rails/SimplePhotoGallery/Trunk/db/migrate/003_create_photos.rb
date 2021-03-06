class CreatePhotos < ActiveRecord::Migration
  def self.up
    create_table :image_attachments do |t|
            t.column :parent_id, :integer
            t.column :content_type, :string
            t.column :filename, :string    
            t.column :thumbnail, :string 
            t.column :size, :integer
            t.column :width, :integer
            t.column :height, :integer
            t.column :type, :string
            t.column :user_id, :integer
            t.column :album_id,  :integer
            t.column :title, :string
            t.column :caption, :text
            t.column :created_at, :string
    end
  end

  def self.down
    drop_table :photos
  end
end
