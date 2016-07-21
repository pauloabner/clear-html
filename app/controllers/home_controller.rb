require "#{Rails.root}/lib/clear_html"
class HomeController < ApplicationController
  def index
    @regexps = regexp_list
  end

  def upload
    file = params['html_file']
    content = ClearHtml.clear file.path
    content.encode!('UTF-16', 'UTF-8', invalid: :replace, replace: '')
    content.encode!('UTF-8', 'UTF-16')
    @content = apply_regexp_library content
  end

  def split
    content = params['content']
    @chapters = split_content content
  end

  private

  def split_content(content)
    content.split('<p><!-- pagebreak --></p>')
  end

  def apply_regexp_library content
    regexp_list.each do |regexp|
      find = Regexp.new regexp['find']
      replace = regexp['replace']
      content.gsub!(find, replace)
    end
    content
  end

  def regexp_list
    JSON.parse(File.read('public/regexp.txt'))
  end
end
