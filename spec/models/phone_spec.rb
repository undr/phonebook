require 'spec_helper'

describe Phone do
  it{ should have_fields(:name).of_type(String) }
  it{ should have_fields(:number).of_type(String) }

  it{ should validate_presence_of(:name) }
  it{ should validate_presence_of(:number) }
  it{ should validate_uniqueness_of(:name) }
  it{ should validate_uniqueness_of(:number) }

  describe '.export' do
    let!(:item1){ Fabricate(:phone) }
    let!(:item2){ Fabricate(:lincolns_phone) }

    specify do
      Phone.export.should eq(<<-CSV
name,number
John F. Kennedy,+1 234 56 78
Abraham Lincoln,+1 876 54 32
CSV
      )
    end
  end
end
