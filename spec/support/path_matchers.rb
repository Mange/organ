module PathHelpers
  class Path
    def initialize(path)
      @path = File.expand_path path
    end

    def to_s() @path end

    def directory?
      File.directory?(@path)
    end

    def exist?
      File.exist?(@path)
    end
    alias existing? exist?

    def write(contents)
      open('w') { |file| file << contents }
      self
    end

    def read
      File.read @path
    end

    def create_directory
      FileUtils.mkdir_p @path
      self
    end

    def create_file
      open('w') { }
      self
    end

    def directory
      Dir.new File.dirname(@path)
    end

    def filename
      File.basename @path
    end

    def dirname
      File.dirname @path
    end

    def expand_path
      File.expand_path @path
    end

    private
    def open(*args, &block)
      FileUtils.mkdir_p File.dirname(@path)
      File.open(@path, *args, &block)
    end
  end

  def path(*args)
    Path.new(*args)
  end
end
