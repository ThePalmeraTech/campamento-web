class AddDetailsToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :full_name, :string
    add_column :users, :phone, :string
    add_column :users, :age, :integer
    add_column :users, :country, :string
    add_column :users, :city, :string
    add_column :users, :previous_experience, :boolean
    add_column :users, :previous_courses, :boolean
    add_column :users, :programming_skill_level, :string
    add_column :users, :motivation, :text
    add_column :users, :course_expectations, :text
    add_column :users, :specific_goals, :text
    add_column :users, :has_reliable_computer, :boolean
    add_column :users, :feedback_on_previous_courses, :text
  end
end
