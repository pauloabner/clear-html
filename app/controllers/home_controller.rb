require "#{Rails.root}/lib/clear_html"
class HomeController < ApplicationController
  def index
    @regexps = regexp_list
  end

  def upload
    file = params['html_file']
    content = ClearHtml.clear_from_file file.path
    content.encode!('UTF-16', 'UTF-8', invalid: :replace, replace: '')
    content.encode!('UTF-8', 'UTF-16')
    @content = apply_regexp_library content
  end

  def split
    content = Nokogiri::HTML(params['content'])
    content = content.css('body').to_html
    @chapters = split_content content.gsub('<body>', '').gsub('</body>', '')
  end

  def generate
    title = params['titulo']
    book = Book.new(title, params['subtitulo'], params['autor'])
    book.chapters_content(params['chapters'])
    file = book.exec
    File.open(file, 'r') do |f|
      send_data f.read.force_encoding('BINARY'), filename: "#{title}.epub", disposition: 'attachment'
    end
    File.delete(file)
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
