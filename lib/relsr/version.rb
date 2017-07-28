module Relsr
  VERSION = '1.0.0'
  class << self
    def version
      File.open(version_filepath, &:readline).strip
    end
    
    private

    def version_filepath
      File.join(__dir__, '../../VERSION')
    end
  end
end
