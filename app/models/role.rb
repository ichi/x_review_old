class Role < ActiveHash::Base
  include ActiveHash::Enum

  self.data = [
    {id: 1, name: 'user'},
    {id: 2, name: 'admin'},
  ]

  enum_accessor :name

  self.all.each do |role|
    define_method "#{role.name}?" do
      self.name == role.name
    end
  end
end
