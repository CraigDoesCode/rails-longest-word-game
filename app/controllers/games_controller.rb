require 'open-uri'
require 'json'

class GamesController < ApplicationController

  def new
    @letters = []
    10.times do
      @letters.push(('a'...'z').to_a.sample)
    end
    # p @letters
  end

  def score
    @guess = params[:guess]
    @grid = params[:letters]
    @time = (Time.now - DateTime.parse(params[:start_time])).round(2)

    document = URI.open("https://wagon-dictionary.herokuapp.com/#{@guess}").read
    @word_info = JSON.parse(document)
    # p params

    @result = 'placeholder'
    if check_guess?(@grid, @guess)
      p @word_info
      @result = 'word in but grid but not a word'
      if @word_info['found'] == true
        score = compute_score(@guess, @time)
        @result = "Well done! your score is #{score} it took you #{@time} seconds"
      end
    end
  end

  def check_guess?(grid, guess)
    guess.split('').each do |l|
      if grid.split.include?(l)
        grid.delete(l)
      else
        return false
      end
    end
    true
  end

  def compute_score(word, time)
    ((word.size / time)*100).round
  end
end
