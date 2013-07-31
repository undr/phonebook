require 'csv'
class Phone
  include Mongoid::Document

  field :name, type: String
  field :number, type: String

  validates :name, :number, presence: true, uniqueness: true

  class << self
    def import file
    end

    def export
      CSV.generate do |csv|
        csv << %w{name number}
        self.each do |phone|
          csv << [phone.name, phone.number]
        end
      end
    end
  end
end
