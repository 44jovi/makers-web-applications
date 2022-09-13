require "spec_helper"
require "rack/test"
require_relative '../../app'

def reset_albums_table
  seed_sql = File.read('spec/seeds/albums_seeds.sql')
  user = ENV['PGUSER1']
  password = ENV['PGPASSWORD']
  connection = PG.connect({ host: '127.0.0.1', dbname: 'music_library_test', user: user, password: password })
  connection.exec(seed_sql)
end

def reset_artists_table
  seed_sql = File.read('spec/seeds/artists_seeds.sql')
  user = ENV['PGUSER1']
  password = ENV['PGPASSWORD']
  connection = PG.connect({ host: '127.0.0.1', dbname: 'music_library_test', user: user, password: password })
  connection.exec(seed_sql)
end

describe Application do
  # reset tables before each test
  before(:each) do 
    reset_albums_table    
    reset_artists_table
  end

  # This is so we can use rack-test helper methods.
  include Rack::Test::Methods

  # We need to declare the `app` value by instantiating the Application
  # class so our tests work.
  let(:app) { Application.new }

  context 'GET /albums' do
    it 'returns all albums' do
      response = get('/albums')

      expected_response = 'Doolittle, Surfer Rosa, Waterloo, Super Trouper, Bossanova, Lover, Folklore, I Put a Spell on You, Baltimore, Here Comes the Sun, Fodder on My Wings, Ring Ring'

      expect(response.status).to eq(200)
      expect(response.body).to eq(expected_response)      
    end

    it 'returns 404 Not Found' do
      response = post('/qwerty123456')
      expect(response.status).to eq(404)
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
      response = post('/qwerty123456')
      expect(response.status).to eq(404)
    end
  end

  context "GET /artists" do
    it 'returns 200 OK and list of artists' do
      response = get('/artists')
      expected_response = "Pixies, ABBA, Taylor Swift, Nina Simone"

      expect(response.status).to eq(200)
      expect(response.body).to eq(expected_response)
    end

    it 'returns 404 Not Found' do
      response = get('/qwerty123456')

      expect(response.status).to eq(404)
    end
  end

  context "POST /artists" do
    it 'returns 200 OK and creates an artist' do
      response = post(
        '/artists',
        name: 'Wild nothing',
        genre: 'Indie'
      )

      expect(response.status).to eq(200)
      expect(response.body).to eq('')

      response = get('/artists')
      expect(response.body).to include('Wild nothing')
    end

    it 'returns 404 Not Found' do
      response = post('/qwerty123456')

      expect(response.status).to eq(404)
    end
  end
  

end
