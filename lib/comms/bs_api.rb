class Comms::BsAPI
  include HTTParty

  base_uri 'http://battle.platform45.com'

  def register(name, email)
    options = { :body => {:name => name, :email => email} }.to_json
    self.class.post('/register', options)
  end
end