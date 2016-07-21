class RegexpController < ApplicationController
  def show
    @content = (File.read('public/regexp.txt')).to_s
  rescue
    @content = 'Um erro aconteceu ao carregar as regexp.'
  end

  def update
    f = File.open('public/regexp.txt', 'w')
    f.write(params['content'])
    f.close
    redirect_to regexp_url
  rescue
    redirect_to regexp_url
  end
end
