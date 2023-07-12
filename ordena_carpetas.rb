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
  when '.deb','.zip', '.rar', '.7z', '.tar','.gz','tgz','.AppImage'
    'comprimidos'
  when '.html', '.css', '.sql'
    'web'
  when '.kml','.kmz'
    'mapas'
  when '.pdf'
    'pdf'
  when '.mp3'
    'musica'
  when '.tif'
    '3d'
  when '.run'
    'programas'
  else
    "otros"
  end
end

def move_file(file_path, destination_path)
  file_name = File.basename(file_path)
  destination_file_path = File.join(destination_path, file_name)

  FileUtils.mv(file_path, destination_file_path)
end

loop do
  puts "¿Qué carpeta deseas limpiar? (Escribe la ruta completa o 'salir' para finalizar)"
  folder_path = gets.chomp

  break if folder_path.downcase == 'salir'

  folder_path = File.expand_path(folder_path, Dir.home)
  if Dir.exist?(folder_path)
    organize_files(folder_path)
    puts "La carpeta ha sido organizada exitosamente."
  else
    puts "La carpeta no existe. Por favor, verifica la ruta e intenta nuevamente."
  end
end