require 'spec_helper'

describe PhonesController do
  describe "GET 'index'" do
    let!(:phones){ [Fabricate(:phone)] }

    before{ get :index }

    specify{ assigns(:phones).should eq(phones) }
    specify{ response.should render_template :index}
    specify{ response.should be_success }
  end

  describe "GET 'new'" do
    context 'with html format' do
      before{ get :new }

      specify{ response.should render_template :new }
      specify{ response.should be_success }
    end

    context 'with js format' do
      before{ get :new, format: :js }

      specify{ response.should render_template :new }
      specify{ response.should be_success }
    end
  end

  describe "POST 'create'" do
    context 'with html format' do
      before{ post :create, phone: Fabricate.attributes_for(:phone) }

      specify{ Phone.count.should eq(1) }
      specify{ response.should redirect_to(phones_path) }
    end

    context 'with js format' do
      before{ post :create, phone: Fabricate.attributes_for(:phone), format: :js }

      specify{ Phone.count.should eq(1) }
      specify{ response.should render_template :create }
    end
  end

  describe "GET 'edit'" do
    context 'with html format' do
      let(:phone){ Fabricate(:phone) }

      before{ get :edit, id: phone.id }

      specify{ assigns(:phone).should eq(phone) }
      specify{ response.should render_template :edit }
      specify{ response.should be_success }
    end

    context 'with js format' do
      let(:phone){ Fabricate(:phone) }

      before{ get :edit, id: phone.id, format: :js }

      specify{ assigns(:phone).should eq(phone) }
      specify{ response.should render_template :edit }
      specify{ response.should be_success }
    end
  end

  describe "PUT 'update'" do
    context 'with html format' do
      let(:phone){ Fabricate(:phone) }

      before{ put :update, id: phone.id, phone: { number: '+1 876 54 32' } }

      specify do
        phone.reload
        phone.number.should eq('+1 876 54 32')
      end
      specify{ assigns(:phone).should eq(phone) }
      specify{ response.should redirect_to(phones_path) }
    end

    context 'with js format' do
      let(:phone){ Fabricate(:phone) }

      before{ put :update, id: phone.id, phone: { number: '+1 876 54 32' }, format: :js }

      specify do
        phone.reload
        phone.number.should eq('+1 876 54 32')
      end
      specify{ assigns(:phone).should eq(phone) }
      specify{ response.should render_template :update }
    end
  end

  describe "DELETE 'destroy'" do
    context 'with html format' do
      let(:phone){ Fabricate(:phone) }

      before{ delete :destroy, id: phone.id }

      specify{ Phone.count.should eq(0) }
      specify{ response.should redirect_to(phones_path) }
    end

    context 'with js format' do
      let(:phone){ Fabricate(:phone) }

      before{ delete :destroy, id: phone.id, format: :js }

      specify{ Phone.count.should eq(0) }
      specify{ response.should render_template :destroy }
    end
  end

  describe "GET 'delete'" do
    let(:phone){ Fabricate(:phone) }

    before{ get :delete, id: phone.id }

    specify{ response.should render_template :delete }
    specify{ response.should be_success }
  end

  describe "GET 'export'", time_freeze: DateTime.now do
    before{ get :export }

    specify{ response.header['Content-Type'].should eq('text/csv') }
    specify{ response.header['Content-Disposition'].should eq("attachment; filename=\"phones-#{DateTime.now.to_s(:number)}.csv\"") }
    specify{ response.should be_success }
  end

  describe "GET 'import'" do
    before{ get :import }

    specify{ response.should render_template :import }
    specify{ response.should be_success }
  end

  describe "POST 'process_import'" do
    let(:file){ fixture_file_upload(Rails.root.join('spec/files/phones.csv').to_s, 'text/csv') }

    before{ post :process_import, file: file }

    specify{ Phone.count.should eq(2) }
    specify{ assigns(:errors).should eq([]) }
    specify{ response.should render_template :process_import }
    specify{ response.should be_success }
  end
end
