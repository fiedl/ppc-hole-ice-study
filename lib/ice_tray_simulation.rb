class IceTraySimulation

  def self.possible_icetray_paths
    [ENV['I3_SRC'], "#{ENV['HOME']}/icetray", "#{ENV['HOME']}/icecube/icetray", "#{ENV['HOME']}/code/icetray"]
  end

  def self.icetray_path
    @icetray_path ||= possible_icetray_paths.detect do |path|
      path if !path.nil? && Dir.exists?(path)
    end || begin
      print "Local icetray source directory not found. Please set the environment variable I3_SRC to the icetray source path.\n"
      exit 1
    end
  end
  
end
