require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = ('A'..'Z').to_a.sample(10)
  end

  def score
    @score = 0
    guess = params[:guess].upcase.split('')
    letters_array = params[:letters_array].split(' ')

    # The word cannot be built out of the original grid
    valid_word = guess.all? do |letter|
      letters_array.include?(letter)
    end

    # The word is valid according to the grid, but is not a valid English word
    url = "https://wagon-dictionary.herokuapp.com/#{params[:guess]}"
    word = open(url).read
    english_word = JSON.parse(word)['found']

    # if !valid_word
    if !valid_word
      @answer = "Sorry but <strong>#{params[:guess]}</strong> cannot be built out of #{params[:letters_array]}.".html_safe
    elsif !english_word
      @answer = "Sorry but <strong>#{params[:guess]}</strong> does not seem to be a valid English word.".html_safe
    else
      # The word is valid according to the grid and is an English word
      @answer = "Congratulations, <strong>#{params[:guess]}</strong> is a valid English word!".html_safe

      @score = params[:guess].length
    end
  end
end
