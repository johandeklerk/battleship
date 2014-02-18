require 'spec_helper'

describe GameController do
  describe 'GET #register' do
    it 'should register the user and return JSON' do
      get :register
      response.should render '{}'
    end
  end
  describe 'GET #salvo' do
    it 'should launch a salvo and return JSON' do
      get :salvo
      response.should render '{}'
    end
  end
end