class Book
  def initialize
    options = Hash.new
    options[:title] = 'Título'
    options[:subtitle] = 'Subtítulo'
    options[:author] = 'Autor'
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
