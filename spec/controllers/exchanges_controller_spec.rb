require 'rails_helper'

RSpec.describe ExchangesController, type: :controller do
  def exchange(attributes = {})
    @exchange ||= FactoryGirl.create(:exchange, attributes)
  end

  context 'when logged in' do
    before(:each) do
      sign_in FactoryGirl.create(:user)
    end

    describe 'GET #index' do
      it "populates an array of all exchanges" do
        get :index
        expect(assigns(:exchanges)).to match_array([exchange])
      end

      it "renders the :index template" do
        get :index
        expect(response).to render_template :index
      end
    end

    describe 'GET #show' do
      it "assigns the requested exchange to @exchange" do
        get :show, id: exchange.id
        expect(assigns(:exchange)).to eq exchange
      end

      it "renders the :show template" do
        get :show, id: exchange.id
        expect(response).to render_template :show
      end
    end

    describe 'POST #load_latest' do
      it "queue CurrenciesUpdater job" do
        expect {
          xhr :post, :load_latest
        }.to change(CurrenciesUpdater.jobs, :size).by(1)
      end

      it "renders the :load_latest template" do
        xhr :post, :load_latest
        expect(response).to render_template :load_latest
      end
    end
  end

  context 'when not logged in' do
    describe "GET #index" do
      it "redirect to signin" do
        get :index
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe "GET #show" do
      it "redirect to signin" do
        get :show, id: exchange.id
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
