require 'fileutils'

task :default => :info

task :info do
  print "
    ## ppc-hole-ice-study

    repo: https://github.com/fiedl/ppc-hole-ice-study

    ### Usage

        rake firing_range
        rake angular_acceptance_scan
"
end

def possible_icetray_paths
  [ENV['I3_SRC'], "#{ENV['HOME']}/icetray", "#{ENV['HOME']}/icecube/icetray", "#{ENV['HOME']}/code/icetray"]
end

def icetray_path
  @icetray_path ||= possible_icetray_paths.detect do |path|
    path if !path.nil? && Dir.exists?(path)
  end || begin
    print "Local icetray source directory not found. Please set the environment variable I3_SRC to the icetray source path.\n"
    exit 1
  end
end

def ppc_path
  "#{ppc_standalone_folder}/ppc" if ppc_standalone_folder
end

def ppc_standalone_folder
  "#{icetray_path}/ppc/private/ppc/gpu" if icetray_path
end

def current_run_id
  @current_run_id ||= `pwgen`.strip || raise("Is pwgen installed?")
end

def current_timestamp
  @current_timestamp ||= Time.now.to_s.gsub(":", "-").gsub(" ", "_").gsub("+0000", "UTC")
end

def current_run_folder_name
  @current_run_folder_name ||= "#{current_timestamp}_#{current_run_id}"
end

def current_run_path
  @current_run_path ||= File.join(__dir__, "runs", current_run_folder_name)
end

def create_ppc_config_file(filename, content)
  file_path = File.join(current_run_path, filename)
  print "Creating config file #{file_path}\n"
  File.write file_path, remove_leading_whitespace(content)
end

def remove_leading_whitespace(string)
  string.split("\n").map(&:strip).join("\n").strip
end

def copy_template_config_file(filename)
  source = File.join(icetray_path, "ppc/resources/ice", filename)
  destination = File.join(current_run_path, filename)
  print "Importing template configuration file #{source}\n"
  FileUtils.cp source, destination
end

task :create_run do
  Dir.mkdir current_run_path
  print "Run id: #{current_run_id}\n"
  print "Run path: #{current_run_path}\n"
end

task :compile_ppc_standalone do
  print "Compiling ppc ...\n  "
  sh "cd #{ppc_standalone_folder} && make gpu > /dev/null"
end

desc "Shoot photons from the side towards a DOM"
task :firing_range => [:compile_ppc_standalone, :create_run] do
  create_ppc_config_file "cfg.txt", "
    # ppc configuration file: follow strict order below
    5     # over-R: DOM radius 'oversize' scaling factor
    1.0   # overall DOM efficiency correction
    0.35  # 0=HG; 1=SAM
    0.9   # g=<cos(theta)>
    
    130.0 # azimuth of major anisotropy axis (deg)
    0.0   # magnitude of major anisotropy coefficient k1
    0.0   # magnitude of minor anisotropy coefficient k2
    
    0.5   # hole ice radius in units of [DOM radius]
    0.03  # hole ice effective scattering length [m]
    100   # hole ice absorption length [m]
    0.35  # hole ice 0=HG; 1=SAM
    0.9   # hole ice g=<cos(theta)>
    
    0.6   # magnitude of major anisotropy coefficient k1
    -0.3  # magnitude of minor anisotropy coefficient k2
    -0.3  # magnitude of minor anisotropy coefficient kz
    
    0.0   # scaling for old absorption anisotropy
    
    0.076795 # p1, sigma along flow
    544284.5 # p2
    2.229494 # p3
    0.002624 # p4
    0.077381 # p1, sigma perpendicular to flow
    1547618. # p2
    2.449589 # p3
    0.002505 # p4
    0.000995 # p1, mean deflection towards the flow
    0.248264 # p2
    2.354436 # p3
    1.680717 # p4                  
  "
  create_ppc_config_file "geo-f2k", "
    TP6P1297 0x5144dd0bba6c -66.7074 276.892 -1773.64 101 101
    TP6P1297 0x5144dd0bba6c -67.7074 276.892 -1773.64 102 101
  "
  copy_template_config_file "as.dat"
  copy_template_config_file "rnd.txt"
  copy_template_config_file "wv.dat"
  copy_template_config_file "icemodel.par"
  copy_template_config_file "icemodel.dat"
  
  sh "export PPCTABLESDIR=#{current_run_path} && \\
    #{ppc_path} 101 101 1.e5 -1 > #{current_run_path}/ppc_hits.txt 2> #{current_run_path}/ppc.log"
  sh "cat #{current_run_path}/ppc.log |grep photons |grep hits"
end

task :angular_acceptance_scan => :create_run
