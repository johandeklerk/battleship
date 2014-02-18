require 'spec_helper'

# I'm using ApplicationController because it's a single page application
describe ApplicationController do
  describe 'GET #index' do
    it 'should render the index page' do
      get :index
      response.should render_template :index
    end
  end
end