class AddTypetoSysteminfo < ActiveRecord::Migration
  def change
   add_column :systeminfos, :teacher, :boolean
  end
end
