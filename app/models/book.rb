class Book
  def initialize(title, subtitle, autor)
    options = Hash.new
    options[:title] = title
    options[:subtitle] = subtitle
    options[:author] = autor
    options[:reference] = 'Referencias'
    options[:cover_path] = 'public/cover.png'

    metadata = Hepub::Metadata.new options
    @book = Hepub::Book.new(metadata, template_dir = 'public/epub_template')
  end

  def exec
    @book.generate("public/EBOOK.epub")
  end

  def chapters_content(content)
    content.each do |chapter_content|
      section = Array.new
      section.push({ :title => 'Titulo da section', :content => chapter_content })
      @book.add_chapter('Titulo Capítulo', 'Autor do Capítulo', section)
    end
  end
end
