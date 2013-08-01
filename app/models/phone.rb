require 'csv'
class Phone
  include Mongoid::Document

  field :name, type: String
  field :number, type: String

  validates :name, :number, presence: true, uniqueness: true

  class << self
    def import string
      invalid_phones = []
      CSV.parse(string, headers: true, col_sep: "\t") do |row|
        next if row.to_a.join.blank?

        name, number = row.fields
        Phone.find_or_initialize_by(name: name).sync_number(number) do |phone|
          invalid_phones << phone
        end
      end
      invalid_phones
    end

    def export
      CSV.generate(col_sep: "\t") do |csv|
        csv << %w{name number}
        self.each do |phone|
          csv << [phone.name, phone.number]
        end
      end
    end
  end

  def sync_number number
    if self.number != number
      self.number = number
      yield self unless save
    end
  end
end
