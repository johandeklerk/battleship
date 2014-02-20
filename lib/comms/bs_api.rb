class Comms::BsAPI
  include HTTParty

  base_uri 'http://battle.platform45.com'

  def register(name, email)
    options = {:body => {:name => name, :email => email}.to_json, :headers => {'Content-Type' => 'application/json'}}
    result = self.class.post('/register', options)
    if result.headers['status'] == '200 OK'
      JSON.parse(result.body)
    end
  end

  def nuke(id, x, y)
    options = {:body => {:id => id, :x => x, :y => y}.to_json, :headers => {'Content-Type' => 'application/json'}}
    result = self.class.post('/nuke', options)
    if result.headers['status'] == '200 OK'
      JSON.parse(result.body)
    end
  end
end