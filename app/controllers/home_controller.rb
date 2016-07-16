require "#{Rails.root}/lib/clear_html"
class HomeController < ApplicationController
  def index
  end
  def upload
    file = params['html_file']
    content = ClearHtml.clear file.path
    render html: content.html_safe
  end
end
