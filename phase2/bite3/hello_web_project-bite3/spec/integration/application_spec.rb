require "spec_helper"
require "rack/test"
require_relative '../../app'

describe Application do
  # This is so we can use rack-test helper methods.
  include Rack::Test::Methods

  # We need to declare the `app` value by instantiating the Application
  # class so our tests work.
  let(:app) { Application.new }
  
    context "GET /names" do
      it 'returns 200 OK' do
        response = get('/names', name1: "Leo", name2: "Leroy", name3: "Jovi")
  
        expect(response.status).to eq(200)
        expect(response.body).to eq "Hello Leo, Leroy, Jovi"
      end
  
      it 'returns 404 Not Found' do
        response = get('/posts?id=276278') # deliberate wrong path
  
        expect(response.status).to eq(404)
      end
    end

    context "POST /sort-names" do
      it 'returns 200 OK' do
        response = post('/sort-names', name1: "Joe", name2: "Alice", name3: "Zoe", name4: "Julia", name5: "Kieran")
  
        expect(response.status).to eq(200)
        expect(response.body).to eq "Alice,Joe,Julia,Kieran,Zoe"
      end
  
      it 'returns 404 Not Found' do
        response = get('/gibberish') # deliberate wrong path
  
        expect(response.status).to eq(404)
      end
    end  
end



# http://localhost:9292/


# # original code
# describe Application do
#   # This is so we can use rack-test helper methods.
#   include Rack::Test::Methods

#   # We need to declare the `app` value by instantiating the Application
#   # class so our tests work.
#   let(:app) { Application.new }

#   context "GET to /" do
#     it "returns 200 OK with the right content" do
#       # Send a GET request to /
#       # and returns a response object we can test.
#       response = get("/")

#       # Assert the response status code and body.
#       expect(response.status).to eq(200)
#       expect(response.body).to eq("Some response data")
#     end
#   end

#   context "POST to /submit" do
#     it "returns 200 OK with the right content" do
#       # Send a POST request to /submit
#       # with some body parameters
#       # and returns a response object we can test.
#       response = post("/submit", name: "Dana", some_other_param: 12)

#       # Assert the response status code and body.
#       expect(response.status).to eq(200)
#       expect(response.body).to eq("Hello Dana")
#     end
#   end
# end
