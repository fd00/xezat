module Xezat
  # detector が多重定義された場合に投げられる例外
  class MultipleDetectorDefinitionError < StandardError
  end

  class DetectorManager
    @@detectors = {}

    # detector を登録する
    def self.register(name, klass)
      raise MultipleDetectorDefinitionError, "'#{name}' already defined" if @@detectors.key?(name)
      @@detectors[name] = klass.new
    end

    # detector をロードする
    def self.load_default_detectors(path = File.expand_path(File.join(File.dirname(__FILE__), 'detector')))
      Dir.glob(File.join(path, '*.rb')) do |rb|
        require rb
      end
    end

    # 登録されている detector で source tree を検証する
    def self.detect(variables)
      tools = []
      @@detectors.each do |name, detector|
        tools << name if detector.detect(variables)
      end
      tools
    end

    def self.[](name)
      @@detectors[name]
    end
  end
end
