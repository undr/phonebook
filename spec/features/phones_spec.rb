require 'spec_helper'

describe "Phones" do
  describe 'Index pade' do
    let!(:item1){ Fabricate(:phone) }
    let!(:item2){ Fabricate(:lincolns_phone) }

    before{ visit '/' }

    it 'should list all phones and link to add new phone' do
      find('table#phones').find("tr#phone-#{item1.id}").should have_content('John F. Kennedy')
      find('table#phones').find("tr#phone-#{item1.id}").should have_content('+1 234 56 78')
      find('table#phones').find("tr#phone-#{item1.id}").should have_link('Edit')
      find('table#phones').find("tr#phone-#{item1.id}").should have_link('Destroy')

      find('table#phones').find("tr#phone-#{item2.id}").should have_content('Abraham Lincoln')
      find('table#phones').find("tr#phone-#{item2.id}").should have_content('+1 876 54 32')
      find('table#phones').find("tr#phone-#{item2.id}").should have_link('Edit')
      find('table#phones').find("tr#phone-#{item2.id}").should have_link('Destroy')

      page.should have_link('Create new')
    end
  end

  describe 'Create phone', driver: :webkit do
    before do
      visit '/'
      click_link('Create new')
    end

    it 'should show form' do
      find('#form-placeholder').find('h1').should have_content('New phone')
      find('#form-placeholder').should have_selector('#new_phone[action="/phones"]')
    end

    context 'fill in' do
      before do
        fill_in 'Name', with: 'Abraham Lincoln'
        fill_in 'Number', with: '+1 876 54 32'
      end

      it 'should add new phone to list' do
        page.should_not have_selector('tr.phone')

        expect{ click_button('Create Phone') and find('tr.phone') }.to change{ Phone.count }.by(1)

        page.should have_content('Abraham Lincoln')
        page.should have_content('+1 876 54 32')
      end
    end
  end

  describe 'Edit phone', driver: :webkit do
    let!(:item){ Fabricate(:phone) }

    before do
      visit '/'
      find("tr#phone-#{item.id}").click_link('Edit')
    end

    it 'should show filled form' do
      find('#form-placeholder').find('h1').should have_content('Editing phone')
      find('#form-placeholder').should have_selector("#edit_phone_#{item.id}[action=\"/phones/#{item.id}\"]")
      find_field('Name').value.should eq('John F. Kennedy')
      find_field('Number').value.should eq('+1 234 56 78')
    end

    context 'when edit' do
      before do
        fill_in 'Name', with: 'John Kennedy'
        fill_in 'Number', with: '+1 234 56 79'
      end

      it 'should add new phone to list' do
        expect{ click_button('Update Phone') and find('tr.phone') }.to_not change{ Phone.count }

        find("tr#phone-#{item.id}").should have_content('John Kennedy')
        find("tr#phone-#{item.id}").should have_content('+1 234 56 79')
      end
    end
  end

  describe 'Edit phone', driver: :webkit do
    let!(:item){ Fabricate(:phone) }

    before do
      visit '/'
    end

    it 'should delete phone from db and page' do
      page.driver.accept_js_confirms!
      expect{ find("tr#phone-#{item.id}").click_link('Destroy') and sleep 3 }.to change{ Phone.count }.by(-1)

      page.should_not have_content('Abraham Lincoln')
      page.should_not have_content('+1 876 54 32')
    end
  end
end
