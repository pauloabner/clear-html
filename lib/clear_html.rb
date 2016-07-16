require 'nokogiri'
require 'byebug'
class ClearHtml

  def self.clear(content)
    doc = File.open(content) { |f| Nokogiri::HTML(f) }
    html = doc.to_html
    html = remove_str(html,"&nbsp;")
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
    html
  end

  private
  def self.remove_str(html, str)
    html.gsub(str, '')
  end

  def self.remove_attr(document, attr)
    html = Nokogiri::HTML(document)
    html.css('*').remove_attr(attr)
    html.to_html
  end

  def self.remove_br_clear_all(document)
    html = Nokogiri::HTML(document)
    html.css('br').each { |br| br.remove if br['clear'] == 'all' }
    html.to_html
  end

  def self.remove_empty_p(document)
    html = Nokogiri::HTML(document)
    html.css('p').each { |p| p.remove if p.text == "\u00A0" }
    html.to_html
  end

  def self.remove_tag(document, tag)
    html = Nokogiri::HTML(document)
    html.css(tag).remove
    html.to_html
  end

  def self.strip_tag(content, tag)
    html = Nokogiri::HTML(content)
    html.css(tag).each { |tag| tag.swap(tag.children) }
    html.to_html
  end
end
