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

  # for this project we will skip 404 errors to reduce number of tests

  before(:each) do
    reset_database_tables
  end

  include Rack::Test::Methods

  let(:app) { Application.new }

  # ------------------
  # tests for /albums
  # ------------------

  context 'GET /albums' do
    it 'returns list of all albums with links' do
      response = get('/albums')

      expect(response.status).to eq(200)
      expect(response.body).to include("<h1>All Albums</h1>")     
      expect(response.body).to include("Title: Doolittle")
      expect(response.body).to include("Released: 1989")  
      expect(response.body).to include('<a href="/albums/1">')            
      expect(response.body).to include("Title: Surfer Rosa")      
      expect(response.body).to include("Released: 1988")
      expect(response.body).to include('<a href="/albums/2">')
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

      response = get('/albums')

      expect(response.body).to include('Bleach')
    end
  end

  # ------------------
  # tests for /artists
  # ------------------

  context "GET /artists" do
    it 'returns list of all artists with links' do
      response = get('/artists')

      expect(response.status).to eq(200)
      expect(response.body).to include("<h1>All Artists</h1>")
      expect(response.body).to include("Pixies")
      expect(response.body).to include('<a href="/artists/1">')
      expect(response.body).to include("ABBA")
      expect(response.body).to include('<a href="/artists/2">')
    end
  end
  
  context "GET /artists/:id" do
    it "returns details of a specified artist ('Doolittle')" do
      response = get("/artists/1")
      
      expect(response.status).to eq(200)
      expect(response.body).to include("<h1>Pixies</h1>")
      expect(response.body).to include("Genre: Rock")
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
  end

end