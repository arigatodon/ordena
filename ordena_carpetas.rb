require 'fileutils'
require 'optparse'

class FileOrganizer
  def initialize(options = {})
    @dry_run = options[:dry_run] || false
    @verbose = options[:verbose] || false
    @moved_files = []
    @errors = []
  end

  def organize_files(folder_path)
    unless Dir.exist?(folder_path)
      log_error("La carpeta no existe: #{folder_path}")
      return false
    end

    unless File.writable?(folder_path)
      log_error("No tienes permisos de escritura en: #{folder_path}")
      return false
    end

    files_processed = 0
    files_moved = 0

    begin
      Dir.foreach(folder_path) do |file|
        next if file == '.' || file == '..'

        file_path = File.join(folder_path, file)
        next unless File.file?(file_path)

        files_processed += 1
        extension = File.extname(file).downcase
        destination_folder = determine_destination_folder(extension)
        
        if destination_folder == 'otros' && extension.empty?
          log_verbose("Saltando archivo sin extensión: #{file}")
          next
        end

        destination_path = File.join(folder_path, destination_folder)
        
        if move_file(file_path, destination_path)
          files_moved += 1
          @moved_files << { file: file, from: folder_path, to: destination_folder }
        end
      end

      show_summary(files_processed, files_moved)
      return true
    rescue => e
      log_error("Error procesando carpeta: #{e.message}")
      return false
    end
  end

  def determine_destination_folder(extension)
    case extension
    # Imágenes
    when '.jpg', '.jpeg', '.png', '.gif', '.bmp', '.svg', '.webp', '.ico', '.tif', '.tiff'
      'imagenes'
    # Videos
    when '.mp4', '.avi', '.mov', '.mkv', '.wmv', '.flv', '.webm', '.m4v', '.3gp'
      'videos'
    # Audio
    when '.mp3', '.wav', '.flac', '.ogg', '.aac', '.wma', '.m4a'
      'musica'
    # Documentos de texto
    when '.doc', '.docx', '.txt', '.md', '.rtf', '.odt'
      'documentos'
    # Hojas de cálculo
    when '.xls', '.xlsx', '.csv', '.ods'
      'hojas_calculo'
    # Presentaciones
    when '.ppt', '.pptx', '.odp'
      'presentaciones'
    # PDF
    when '.pdf'
      'pdf'
    # Archivos comprimidos
    when '.zip', '.rar', '.7z', '.tar', '.gz', '.tgz', '.bz2', '.xz', '.deb', '.rpm', '.appimage'
      'comprimidos'
    # Código fuente
    when '.rb', '.py', '.js', '.html', '.css', '.java', '.cpp', '.c', '.php', '.go', '.rs', '.sql'
      'codigo'
    # Mapas
    when '.kml', '.kmz'
      'mapas'
    # Ejecutables
    when '.exe', '.msi', '.dmg', '.run', '.app'
      'programas'
    # Otros
    else
      'otros'
    end
  end

  def move_file(file_path, destination_path)
    file_name = File.basename(file_path)
    destination_file_path = File.join(destination_path, file_name)

    if @dry_run
      puts "DRY RUN: Movería #{file_path} -> #{destination_file_path}"
      return true
    end

    begin
      FileUtils.mkdir_p(destination_path) unless Dir.exist?(destination_path)
      
      # Manejar archivos duplicados
      if File.exist?(destination_file_path)
        counter = 1
        base_name = File.basename(file_name, File.extname(file_name))
        extension = File.extname(file_name)
        
        loop do
          new_name = "#{base_name}_#{counter}#{extension}"
          destination_file_path = File.join(destination_path, new_name)
          break unless File.exist?(destination_file_path)
          counter += 1
        end
        
        log_verbose("Archivo duplicado, renombrando a: #{File.basename(destination_file_path)}")
      end

      FileUtils.mv(file_path, destination_file_path)
      log_verbose("Movido: #{file_name} -> #{File.basename(destination_path)}/")
      return true
    rescue => e
      log_error("Error moviendo #{file_name}: #{e.message}")
      return false
    end
  end

  def log_verbose(message)
    puts message if @verbose
  end

  def log_error(message)
    puts "ERROR: #{message}"
    @errors << message
  end

  def show_summary(processed, moved)
    puts "\n--- Resumen ---"
    puts "Archivos procesados: #{processed}"
    puts "Archivos movidos: #{moved}"
    puts "Errores: #{@errors.length}"
    
    if @verbose && !@moved_files.empty?
      puts "\nArchivos movidos:"
      @moved_files.each do |file_info|
        puts "  #{file_info[:file]} -> #{file_info[:to]}/"
      end
    end
    
    unless @errors.empty?
      puts "\nErrores encontrados:"
      @errors.each { |error| puts "  - #{error}" }
    end
  end
end

# Función para mantener compatibilidad con el script original
def organize_files(folder_path)
  organizer = FileOrganizer.new
  organizer.organize_files(folder_path)
end

# Parsear argumentos de línea de comandos
options = {}
OptionParser.new do |opts|
  opts.banner = "Uso: ruby #{$0} [opciones] [carpeta]"
  
  opts.on("--dry-run", "Ver qué archivos se moverían sin ejecutar") do
    options[:dry_run] = true
  end
  
  opts.on("-v", "--verbose", "Mostrar detalles de cada operación") do
    options[:verbose] = true
  end
  
  opts.on("-h", "--help", "Mostrar esta ayuda") do
    puts opts
    exit
  end
end.parse!

# Si se proporciona una carpeta como argumento, procesarla y salir
if ARGV.length > 0
  folder_path = File.expand_path(ARGV[0])
  organizer = FileOrganizer.new(options)
  
  if organizer.organize_files(folder_path)
    puts "La carpeta ha sido organizada exitosamente."
  else
    puts "Hubo errores al organizar la carpeta."
    exit 1
  end
else
  # Modo interactivo original
  organizer = FileOrganizer.new(options)
  
  puts "=== Organizador de Archivos ==="
  puts "Opciones activas:" 
  puts "  - Modo dry-run: #{options[:dry_run] ? 'SÍ' : 'NO'}"
  puts "  - Modo verbose: #{options[:verbose] ? 'SÍ' : 'NO'}"
  puts ""

  loop do
    puts "¿Qué carpeta deseas limpiar? (Escribe la ruta completa o 'salir' para finalizar)"
    folder_path = gets.chomp

    break if folder_path.downcase == 'salir'

    folder_path = File.expand_path(folder_path, Dir.home)
    
    if organizer.organize_files(folder_path)
      puts "La carpeta ha sido organizada exitosamente."
    else
      puts "Hubo errores al organizar la carpeta."
    end
    puts ""
  end
end