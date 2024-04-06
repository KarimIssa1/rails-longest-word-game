class GamesController < ApplicationController
  def new
    @letters = generate_random_letters
  end

  def score
    @word = params[:word].upcase.strip
    letters_string = params[:letters] || ''
    @letters = letters_string.split('')
    @valid_word = valid_word?(@word)
    @word_in_grid = word_in_grid?(@word, @letters)

    if @valid_word && @word_in_grid
      update_score(@word.length)
      @result = "#{@word} is a valid English word and was built from the grid."
    elsif @word_in_grid
      update_score(0)
      @result = "#{@word} is not a valid English word but was built from the grid."
    else
      update_score(0)
      @result = "#{@word} can't be built out of the original grid."
    end

    @total_score = session[:total_score]
  end

  def reset
    session[:total_score] = 0
    redirect_to new_path
  end

  private

  def generate_random_letters
    Array.new(10) { ('A'..'Z').to_a.sample }
  end

  def valid_word?(word)
    uri = URI("https://wagon-dictionary.herokuapp.com/#{word}")
    response = Net::HTTP.get(uri)
    result = JSON.parse(response)
    result['found']
  end

  def word_in_grid?(word, letters)
    word.chars.all? { |letter| word.count(letter) <= letters.count(letter) }
  end

  def update_score(points)
    session[:total_score] ||= 0
    session[:total_score] += points
  end
end
