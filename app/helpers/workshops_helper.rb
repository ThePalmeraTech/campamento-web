# En app/helpers/workshops_helper.rb
module WorkshopsHelper
  def fields_for_lesson(f)
    new_object = f.object.lessons.build
    fields = f.simple_fields_for(:lessons, new_object, child_index: "new_lessons") do |builder|
      render('lessons/lesson_fields', f: builder)
    end
    fields.gsub("\n", "")
  end
end
