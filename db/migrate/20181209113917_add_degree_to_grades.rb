class AddDegreeToGrades < ActiveRecord::Migration
  def change
    add_column :grades, :degree, :boolean, null: false, default: false 
  end
end
