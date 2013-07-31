class PhonesController < ApplicationController
  respond_to :js, :html
  before_filter :find_model, except: [:index, :new, :create, :export, :inport]

  def index
    @phones = Phone.all
  end

  def new
    @phone = Phone.new

    respond_with do |format|
      format.html { render layout: !request.xhr? }
    end
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
    send_data Phone.export, type: 'text/csv', filename: "phones-#{DateTime.now.to_s(:number)}", disposition: 'inline'
  end

  private

  def find_model
    @phone = Phone.find(params[:id])
  end
end
