class Phone
  include Mongoid::Document

  field :name, type: String
  field :number, type: String

  validates :name, :number, presence: true, uniqueness: true
end
