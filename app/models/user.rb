class User < ActiveRecord::Base
  before_save { self.email = email.downcase }

  validates :name, length: { minimum: 1, maximum: 100 }, presence: true

  validates :password, presence: true, length: { minimum: 6 }, unless: :password_digest
  validates :password, length: { minimum: 6 }, allow_blank: true

  validates :email,
            presence: true,
            uniqueness: { case_sensitive: false },
            length: { minimum: 3, maximum: 254 }

  has_secure_password

  # Split the user's name on a space (e.g. between a first name and a last name). Loop over each name and uppercase the first letter. Re-combine the first and last names with a space in-between and save it to the name attribute.
  def set_uppercase
     name_array = []
     if name != nil
       name.split.each do |name_part|
         next if name_part == nil
         name_array << name_part.capitalize
       end

       self.name = name_array.join(" ")
     end
   end

   before_save :set_uppercase
end
