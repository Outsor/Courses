class AddSemesterToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :semester, :string,  default: "2018-1"
  end
end
