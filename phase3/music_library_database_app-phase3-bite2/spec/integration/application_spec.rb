require "spec_helper"
require "rack/test"
require_relative '../../app'

def reset_database_tables
  seed_sql_1 = File.read('spec/seeds/artists_seeds.sql')
  seed_sql_2 = File.read('spec/seeds/albums_seeds.sql')
  user = ENV['PGUSER1']
  password = ENV['PGPASSWORD']
  connection = PG.connect({ host: '127.0.0.1', dbname: 'music_library_test', user: user, password: password })
  connection.exec(seed_sql_1)
  connection.exec(seed_sql_2)
end

describe Application do
  
  before(:each) do
    reset_database_tables
  end

  include Rack::Test::Methods

  let(:app) { Application.new }

  # ------------------
  # tests for /albums
  # ------------------

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

  context "GET /albums/:id" do
    it "returns details of a specified album ('Doolittle')" do
      response = get("/albums/1")
      
      expect(response.status).to eq(200)

      expect(response.body).to include("<h1>Doolittle</h1>")
      expect(response.body).to include("Release year: 1989")
      expect(response.body).to include("Artist: Pixies")
    end

    it "returns details of a specified album ('Surfa Rosa')" do
      response = get("/albums/2")
      
      expect(response.status).to eq(200)

      expect(response.body).to include("<h1>Surfer Rosa</h1>")
      expect(response.body).to include("Release year: 1988")
      expect(response.body).to include("Artist: Pixies")
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

  # ------------------
  # tests for /artists
  # ------------------

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