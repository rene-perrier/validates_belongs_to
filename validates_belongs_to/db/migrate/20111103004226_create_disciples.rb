class CreateDisciples < ActiveRecord::Migration
  def self.up
    create_table :disciples do |t|
      t.string :name, :null => false
      t.integer :master_id, :null => false
    end
    connection.execute "ALTER TABLE disciples ADD CONSTRAINT disciples_ibfk_1 FOREIGN KEY (master_id) REFERENCES masters (id);"
  end

  def self.down
    drop_table :disciples
  end
end
