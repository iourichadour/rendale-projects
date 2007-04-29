# This file is autogenerated. Instead of editing this file, please use the
# migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.

ActiveRecord::Schema.define(:version => 6) do

  create_table "attachment_binaries", :force => true do |t|
    t.column "attachment_id", :integer, :default => 0, :null => false
    t.column "data", :binary, :default => "", :null => false
  end

  create_table "attachments", :force => true do |t|
    t.column "attachable_id", :integer
    t.column "attachable_type", :string
    t.column "type", :string
    t.column "comment", :text
    t.column "name", :string
    t.column "content_type", :string
  end

  create_table "profiles", :force => true do |t|
    t.column "user_id", :integer
    t.column "first_name", :string
    t.column "last_name", :string
    t.column "birth_date", :date
    t.column "bio", :text
  end

  create_table "users", :force => true do |t|
    t.column "login", :string
    t.column "email", :string
    t.column "crypted_password", :string, :limit => 40
    t.column "salt", :string, :limit => 40
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
    t.column "remember_token", :string
    t.column "remember_token_expires_at", :datetime
  end

end
