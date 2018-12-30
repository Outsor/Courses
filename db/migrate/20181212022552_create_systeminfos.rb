class CreateSysteminfos < ActiveRecord::Migration
  def change
    create_table :systeminfos do |t|
      t.string :semester, 			null:false, default: "2018-1"
      t.datetime :cs_start,			null:false, default: Time.now
      t.datetime :cs_end, 			null:false, default: Time.now

      t.timestamps null: false
    end
  end
end
