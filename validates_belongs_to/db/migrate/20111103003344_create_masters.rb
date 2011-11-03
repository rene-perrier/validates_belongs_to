class CreateMasters < ActiveRecord::Migration
  def self.up
    create_table :masters do |t|
      t.string :name, :null => false
      t.text :wisdom, :null => false
    end
  end

  def self.down
    drop_table :masters
  end
end
