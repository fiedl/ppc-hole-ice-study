require 'fileutils'
require 'fiedl/log'
require 'active_support/concern'
require 'active_support/core_ext/module/concerning'

require_relative './ice_tray_simulation.rb'


class PpcSimulation < IceTraySimulation
  attr_accessor :directory
  
  def initialize(directory:)
    self.directory = directory
  end

  concerning :Execution do
    def perform(argument)
      import_missing_configuration_files
      execute_ppc argument
    end

    def execute_ppc(argument)
      shell "export PPCTABLESDIR=#{directory} && " +
            "#{self.class.ppc_path} #{argument} " +
            "> #{directory}/ppc_hits.txt " +
            "2> #{directory}/ppc.log"
    end
  end

  concerning :GeometryConfiguration do
    def configure_geometry(content)
      write_configuration_file "geo-f2k", content
    end
  end

  concerning :ConfigurationFiles do
    def write_configuration_file(filename, content)
      log.info "  Generating config file #{directory}/#{filename}"
      File.write "#{directory}/#{filename}", remove_leading_whitespace(content)
    end

    def remove_leading_whitespace(string)
      string.split("\n").map(&:strip).join("\n").strip
    end
    
    def import_missing_configuration_files
      %w(cfg.txt geo-f2k as.dat rnd.txt wv.dat icemodel.par icemodel.dat).each do |config_filename|
        import_config_file config_filename unless File.exists? "#{directory}/#{config_filename}"
      end
    end

    def import_config_file(filename)
      source = File.join(self.class.icetray_path, "ppc/resources/ice", filename)
      destination = File.join(directory, filename)
      log.info "  Importing template config #{source}"
      FileUtils.cp source, destination
    end
  end

  concerning :PpcBinary do
    class_methods do
      def ppc_path
        "#{ppc_standalone_folder}/ppc" if ppc_standalone_folder
      end
    
      def ppc_standalone_folder
        "#{icetray_path}/ppc/private/ppc/gpu" if icetray_path
      end

      def compile
        compile_standalone_ppc
      end
      
      def compile_standalone_ppc
        shell "cd #{ppc_standalone_folder} && make gpu > /dev/null"
      end
    end
  end
end
