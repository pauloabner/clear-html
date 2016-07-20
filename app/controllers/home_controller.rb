require "#{Rails.root}/lib/clear_html"
class HomeController < ApplicationController
  def index
  end

  def upload
    file = params['html_file']
    @content = ClearHtml.clear file.path
    @content.encode!('UTF-16', 'UTF-8', invalid: :replace, replace: '')
    @content.encode!('UTF-8', 'UTF-16')
  end

  def split
    content = params['content']
    @chapters = split_content content
  end

  private

  def split_content(content)
    content.split('<p><!-- pagebreak --></p>')
  end
end
