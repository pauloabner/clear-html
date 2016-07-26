class Book
  def initialize(title, subtitle, autor, images_zip_file = 'public/images_zip_file.zip')
    options = Hash.new
    options[:title] = title
    options[:subtitle] = subtitle
    options[:author] = autor
    options[:reference] = 'Referencias'
    template_dir = create_folder(images_zip_file)
    options[:cover_path] = "#{template_dir}/images/cover.png"
    metadata = Hepub::Metadata.new options
    @book = Hepub::Book.new(metadata, template_dir)
  end

  def exec
    @book.generate("public/EBOOK.epub")
  end

  def chapters_content(content)
    content.each do |chapter_content|
      section = Array.new
      chapter_content.encode!('UTF-16', 'UTF-8', invalid: :replace, replace: '')
      chapter_content.encode!('UTF-8', 'UTF-16')
      section.push({ :title => '', :content => chapter_content })
      @book.add_chapter('Titulo Capítulo', '', section)
    end
  end

  private

  def create_folder(images_zip_file)
    default_folder = 'public/epub_template'
    folder = "tmp/#{Time.now.to_i}"
    Dir.mkdir(folder) unless Dir.exists? folder
    FileUtils.cp_r("#{default_folder}/.", folder)
    copy_images(images_zip_file, folder) if images_zip_file.present?
    folder
  rescue
    default_folder
  end

  def copy_images(image_zip_file, dest_folder)
    Zip::File.open(image_zip_file) do |zip_file|
      zip_file.each do |entry|
        entry.extract("#{dest_folder}/images/#{entry.name}")
      end
    end
  end
end
