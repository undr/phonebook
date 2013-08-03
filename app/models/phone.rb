require 'csv'
class Phone < ActiveRecord::Base
  validates :name, :number, presence: true, uniqueness: true
  validates :number, format: {with: /^\+?([\d\#\s\-])*$/}

  class << self
    def import string, destroy_all = false
      invalid_phones = []

      Phone.transaction do
        Phone.destroy_all if destroy_all

        CSV.parse(string, headers: true, col_sep: "\t") do |row|
          next if row.to_a.join.blank?

          name, number = row.fields
          Phone.where(name: name).first_or_initialize.sync_number(number){|phone| invalid_phones << phone }
        end
      end
      invalid_phones
    end

    def export
      CSV.generate(col_sep: "\t") do |csv|
        csv << %w{name number}
        self.all.each do |phone|
          csv << [phone.name, phone.number]
        end
      end
    end
  end

  def sync_number number
    return if number.blank? && self.new_record?
    return self.destroy if number.blank?

    if self.number != number
      self.number = number
      yield self unless save
    end
  end
end
