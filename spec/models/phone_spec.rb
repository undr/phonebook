require 'spec_helper'

describe Phone do
  it{ should have_fields(:name).of_type(String) }
  it{ should have_fields(:number).of_type(String) }

  it{ should validate_presence_of(:name) }
  it{ should validate_presence_of(:number) }
  it{ should validate_uniqueness_of(:name) }
  it{ should validate_uniqueness_of(:number) }

  let(:csv_data){ <<-CSV
name\tnumber
John F. Kennedy\t+1 234 56 78
Abraham Lincoln\t+1 876 54 32
CSV
  }

  describe '.export' do
    let!(:item1){ Fabricate(:phone) }
    let!(:item2){ Fabricate(:lincolns_phone) }

    specify{ Phone.export.should eq(csv_data) }
  end

  describe '.import' do
    context 'with empty phonebook' do
      before{ Phone.import(csv_data) }

      specify{ Phone.count.should eq(2) }
      specify{ Phone.first.name.should eq('John F. Kennedy') }
      specify{ Phone.first.number.should eq('+1 234 56 78') }
      specify{ Phone.last.name.should eq('Abraham Lincoln') }
      specify{ Phone.last.number.should eq('+1 876 54 32') }
    end

    context 'with same items in phonebook' do
      let!(:item1){ Fabricate(:phone) }
      let!(:item2){ Fabricate(:lincolns_phone, number: '+12 987 65 43') }

      it 'should not add new items' do
        Phone.import(csv_data)
        Phone.count.should eq(2)
      end

      it 'should change phone number' do
        Phone.import(csv_data)
        item2.reload
        item2.number.should eq('+1 876 54 32')
      end
    end

    context 'with only one same item in phonebook' do
      let!(:item1){ Fabricate(:phone) }
      let!(:item2){ Fabricate(:phone, name: 'Richard Nixon', number: '+12 987 65 43') }

      it 'should add new item' do
        Phone.import(csv_data)
        Phone.count.should eq(3)
      end
    end

    context 'with validation errors' do
      let!(:item1){ Fabricate(:phone) }
      let!(:item2){ Fabricate(:lincolns_phone, name: 'Richard Nixon') }

      subject{Phone.import(csv_data)}

      its(:size){ should eq(1) }
      its('first.name'){ should eq('Abraham Lincoln') }
      its('first.number'){ should eq('+1 876 54 32') }
    end
  end
end
