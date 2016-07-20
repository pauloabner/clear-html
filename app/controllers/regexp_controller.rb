class RegexpController < ApplicationController
  def show
    @content = file_to_str('public/regexp.txt')
  end

  private

  def file_to_str(file_path)
      file = File.open(file_path, 'r')
      data = ''
      file.each_line do |line|
        data += line unless line.empty?
      end
      data
    end
end
