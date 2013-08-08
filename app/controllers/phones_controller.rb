class PhonesController < ApplicationController
  respond_to :js, :html
  before_filter :find_model, except: [:index, :new, :create, :export, :import, :process_import, :search]

  def index
    @phones = params[:query].present? ? Phone.elastic_search(params[:query]) : Phone.order('name')
    @phone = Phone.new
  end

  def new
    @phone = Phone.new

    respond_with(@phone)
  end

  def edit
  end

  def create
    @phone = Phone.create(params[:phone])

    respond_with do |format|
      format.html{ redirect_to phones_path }
    end
  end

  def update
    @phone.update_attributes(params[:phone])

    respond_with do |format|
      format.html{ redirect_to phones_path }
    end
  end

  def destroy
    @phone.destroy

    respond_with do |format|
      format.html{ redirect_to phones_path }
    end
  end

  def delete
  end

  def export
    send_data Phone.export_csv, type: 'text/csv', filename: "phones-#{DateTime.now.to_s(:number)}.csv", disposition: 'attachment'
  end

  def process_import
    @errors = Phone.import_csv(params[:file].read, !!params[:destroy_all])
  end

  private

  def find_model
    @phone = Phone.find(params[:id])
  end
end
