class RegexpController < ApplicationController
  def show
    @content = (File.read('public/regexp.txt')).to_s
  rescue
    @content = 'Um erro aconteceu ao carregar as regexp.'
  end

  def update
    redirect_to regexp_url
  end
end
