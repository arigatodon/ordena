require 'fileutils'

def organize_files(folder_path)
  formats  = []
  Dir.foreach(folder_path) do |file|
    formats << file.split('.').last
    next if file == '.' || file == '..'

    file_path = File.join(folder_path, file)
    next unless File.file?(file_path)

    extension = File.extname(file).downcase
    destination_folder = determine_destination_folder(extension)
    next if destination_folder.nil?

    destination_path = File.join(folder_path, destination_folder)
    FileUtils.mkdir_p(destination_path) unless Dir.exist?(destination_path)

    move_file(file_path, destination_path)
  end
end

def determine_destination_folder(extension)
  case extension
  when '.jpg', '.png', '.gif', '.jpeg'
    'imagenes'
  when '.mp4', '.avi', '.mov'
    'videos'
  when '.doc', '.docx', '.xls', '.xlsx'
    'documentos'
  when '.zip', '.rar', '.7z'
    'comprimidos'
  when '.html', '.css', '.sql'
    'web'
  when '.kml','.kmz'
    'mapas'
  else
    "otros"
  end
end

def move_file(file_path, destination_path)
  file_name = File.basename(file_path)
  destination_file_path = File.join(destination_path, file_name)

  FileUtils.mv(file_path, destination_file_path)
end

# Ruta de la carpeta de Descargas
downloads_folder = File.expand_path('Descargas', Dir.home)

organize_files(downloads_folder)

