require "spec_helper"
require "rack/test"
require_relative '../../app'

describe Application do
  # This is so we can use rack-test helper methods.
  include Rack::Test::Methods

  # We need to declare the `app` value by instantiating the Application
  # class so our tests work.
  let(:app) { Application.new }

  context 'GET /albums' do
    it 'returns all albums' do
      response = get('/albums')

      result = 'Surfer Rosa, Waterloo, Super Trouper, Bossanova, Lover, Folklore, I Put a Spell on You, Baltimore, Here Comes the Sun, Fodder on My Wings, Ring Ring'

      expect(response.status).to eq(200)
      expect(response.body).to eq(result)      
    end
  end

  context "POST /albums" do
    it 'creates a new album' do
      response = post(
        '/albums',
        title: 'Bleach',
        release_year: '1989',
        artist_id: '44'
      )

      expect(response.status).to eq(200)
      expect(response.body).to eq('Album created!')

      # check to see if it appears on new list of albums:
      response = get('/albums')
      expect(response.body).to include('Bleach')
    end

    it 'returns 404 Not Found' do
      response = post('/albumsqwerty')

      expect(response.status).to eq(404)
    end
  end

end
