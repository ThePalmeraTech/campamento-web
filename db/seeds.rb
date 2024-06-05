# Seed para crear un usuario con imágenes adjuntas
user = User.create!(
  email: Faker::Internet.email,
  password: Faker::Internet.password(min_length: 8),  # Genera una contraseña aleatoria
  full_name: Faker::Name.name,
  phone: Faker::PhoneNumber.phone_number,
  age: Faker::Number.between(from: 18, to: 70),
  country: Faker::Address.country,
  city: Faker::Address.city,
  previous_experience: Faker::Boolean.boolean,
  previous_courses: Faker::Boolean.boolean,
  programming_skill_level: Faker::Lorem.word,
  motivation: Faker::Lorem.paragraph,
  course_expectations: Faker::Lorem.paragraph,
  specific_goals: Faker::Lorem.paragraph,
  has_reliable_computer: Faker::Boolean.boolean,
  feedback_on_previous_courses: Faker::Lorem.paragraph,
  approved: Faker::Boolean.boolean,
  payment_method: Faker::Lorem.word,
  payment_option: Faker::Lorem.word,
)

# Adjunta imágenes aleatorias para los comprobantes de pago
user.full_payment_proof.attach(io: File.open(Rails.root.join('public', 'images', 'lesson-1', 'html_skeleton.jpg')), filename: 'html_skeleton.jpg', content_type: 'image/jpeg')
user.reservation_payment_proof.attach(io: File.open(Rails.root.join('public', 'images', 'lesson-1', 'html_skeleton.jpg')), filename: 'html_skeleton.jpg', content_type: 'image/jpeg')
