require 'csv'
class Phone < ActiveRecord::Base
  include Tire::Model::Search
  include Tire::Model::Callbacks

  validates :name, :number, presence: true, uniqueness: true
  validates :number, format: {with: /^\+?([\d\#\s\-])*$/}

  # after_touch{ tire.update_index }

  mapping do
    indexes :id, type: 'long', index: 'not_analyzed'
    indexes :name, type: 'string', boost: 1.5, analyzer: 'snowball'
    indexes :normalized_number, type: 'string', analyzer: 'snowball'
    # indexes :number, index: 'not_analyzed', store: false
  end

  def normalized_number
    number.gsub(/[^\d]/, '')
  end

  def to_indexed_json
    {id: id, name: name, normalized_number: normalized_number}.to_json
    #to_json(except: :number, include: :normalized_number)
  end

  class << self
    def elastic_search query
      search(load: true){ query{ string "#{query}*" } }.results
    end

    def import_csv string, destroy_all = false
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

    def export_csv
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
