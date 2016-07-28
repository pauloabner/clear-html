require 'nokogiri'
#ClearHtml
class ClearHtml
  def self.clear_from_file(file)
    doc = File.open(file) { |f| Nokogiri::HTML(f, nil, 'UTF-8') }
    html = doc.css('body').to_html
    clear(html)
  end

  def self.clear(html)
    html = remove_attr(html, 'align')
    html = remove_br_clear_all(html)
    html = remove_attr(html, 'class')
    html = remove_attr(html, 'height')
    html = remove_tag(html, 'meta')
    html = remove_attr(html, 'style')
    html = remove_attr(html, 'width')
    html = strip_tag(html, 'span')
    html = strip_tag(html, 'div')
    html = remove_empty_p(html)
    html = change_img_src(html)
    html = remove_str(html, '&nbsp;')
    html = close_img(html)
    html
  end

  def self.remove_str(html, str)
    unless html.valid_encoding?
      html = html.encode("UTF-16be", :invalid=>:replace, :replace=>"?").encode('UTF-8')
    end
    html.gsub(str, '')
  end

  def self.remove_attr(document, attr)
    html = Nokogiri::HTML(document, nil, 'UTF-8')
    html.css('*').remove_attr(attr)
    html.to_html
  end

  def self.remove_br_clear_all(document)
    html = Nokogiri::HTML(document, nil, 'UTF-8')
    html.css('br').each { |br| br.remove if br['clear'] == 'all' }
    html.to_html
  end

  def self.remove_empty_p(document)
    html = Nokogiri::HTML(document, nil, 'UTF-8')
    html.css('p').each { |p| p.remove if p.text == "\u00A0" }
    html.to_html
  end

  def self.remove_tag(document, tag)
    html = Nokogiri::HTML(document, nil, 'UTF-8')
    html.css(tag).remove
    html.to_html
  end

  def self.strip_tag(content, tag)
    html = Nokogiri::HTML(content, nil, 'UTF-8')
    html.css(tag).each { |t| t.swap(t.children) }
    html.to_html
  end

  def self.change_img_src(document)
    html = Nokogiri::HTML(document, nil, 'UTF-8')
    html.css('img').each do |img|
      filename = img['src'].split('/').last
      img['src'] = "images/#{filename}"
    end
    html.to_html
  end

  def self.close_img(content)
    new_str = ''
    index_img = content.index('<img')
    until index_img.nil? do
    	new_str += content[0, index_img + 4]
    	content = content[index_img + 4, content.length]
    	index_next_slash = content.index('>')
    	content = content.sub('>', '/>') unless content[index_next_slash - 1] == '/'
    	index_img = content.index('<img')
    end
    new_str + content
  end
end
