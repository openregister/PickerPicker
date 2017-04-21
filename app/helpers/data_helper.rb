require 'rubygems'
require 'zip'

module DataHelper
  def zipCodeFilesHelper()
    filesToZip = ['picker.html', 'picker-data.json']
    destination = Rails.root.join("app", "assets", "static", "code.zip")

    Zip::File.open(destination, Zip::File::CREATE) do |zipFile|
      filesToZip.each do |filename|
        zipFile.add(filename, destination)
      end
    end
  end
end
