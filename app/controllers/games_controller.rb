class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
  end

  def score
    @word = params[:word]
    current_score = @word.length
    session[:total_score] ||= 0
    session[:total_score] += current_score
    @total_score = session[:total_score]
  end

  def reset
    session[:total_score] = 0
    redirect_to new_path
  end
end
