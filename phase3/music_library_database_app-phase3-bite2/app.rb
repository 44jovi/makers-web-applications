# file: app.rb
require 'sinatra'
require "sinatra/reloader"
require_relative 'lib/database_connection'
require_relative 'lib/album_repository'
require_relative 'lib/artist_repository'

DatabaseConnection.connect

class Application < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
    also_reload 'lib/album_repository'
    also_reload 'lib/artist_repository'
  end

  get '/albums' do
    @albums = AlbumRepository.new.all
    return erb(:albums)
  end

  # see end of this file for my original inefficient solution
  get '/albums/:id' do
    album_repo = AlbumRepository.new
    @album = album_repo.find(params[:id])

    artist_repo = ArtistRepository.new
    @artist = artist_repo.find(@album.artist_id) 

    return erb(:album)
  end

  post '/albums' do
    album = Album.new         
    album.title = params[:title]
    album.release_year = params[:release_year]
    album.artist_id = params[:artist_id]

    repo = AlbumRepository.new
    repo.create(album)

    return "Album created!"
  end

  get '/artists' do
    repo = ArtistRepository.new
    artists = repo.all

    response = artists.map do |artist|
      artist.name
    end.join(', ')
  end

  post '/artists' do
    artist = Artist.new         
    artist.name = params[:name]
    artist.genre = params[:genre]

    repo = ArtistRepository.new
    repo.create(artist)

    return "" # this time return nothing, unlike when POST /albums
  end



end

# # my original solution for get '/albums/:id'
# get '/albums/:id' do
#   repo = AlbumRepository.new
#   album = repo.find(params[:id])

#   @album_title = album.title
#   @album_release_year = album.release_year
#   @album_artist_id = album.artist_id

#   repo = ArtistRepository.new
#   artist = repo.find(@album_artist_id)
#   @artist_name = artist.name

#   return erb(:index)
# end