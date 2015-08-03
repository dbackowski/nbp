require 'rails_helper'

RSpec.describe ReportsController, type: :controller do
  context 'when logged in' do
    before(:each) do
      sign_in FactoryGirl.create(:user)
      FactoryGirl.create(:currency)
    end

    describe 'GET #show' do
      it "populates an array of all reports" do
        get :show
        expect(assigns(:report)).to be_present
      end

      it "renders the :show template" do
        get :show
        expect(response).to render_template :show
      end
    end
  end

  context 'when not logged in' do
    describe "GET #show" do
      it "redirect to signin" do
        get :show
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
