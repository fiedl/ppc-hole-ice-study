require 'fileutils'
require 'benchmark'
require 'fiedl/log'

require_relative 'lib/ppc_simulation.rb'


task :default => :help

task :help => :info do
  log.section "Usage"
  log.info "    rake firing_range"
  log.info "    rake firing_range_with_varying_hole_ice_radius"
  log.info "    rake angular_acceptance_scan"
end

task :info do
  log.head "ppc-hole-ice-study"
  log.info "repo: https://github.com/fiedl/ppc-hole-ice-study"
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
  File.join(__dir__, "runs", current_run_folder_name)
end

def current_sub_run_folder_name
  @current_sub_run
end

def current_sub_run_path
  File.join(__dir__, "runs", current_run_folder_name, current_sub_run_folder_name)
end


task :setup => :info do
  log.section "Simulation setup"

  log.info "Compiling ppc ..."
  PpcSimulation.compile

  log.info "Creating run folder ..."
  FileUtils.mkdir_p current_run_path
  log.info "  #{current_run_path}"
end

desc "Shoot photons from the side towards a DOM"
task :firing_range => :setup do
  log.section "Configure simulation"
  sim = PpcSimulation.new(directory: current_run_path)

  sim.write_configuration_file "cfg.txt", "
    # ppc configuration file: follow strict order below
    1     # over-R: DOM radius 'oversize' scaling factor
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

  sim.configure_geometry "
    TP6P1297 0x5144dd0bba6c -66.7074 276.892 -1773.64 101 101
    TP6P1297 0x5144dd0bba6c -67.7074 276.892 -1773.64 102 101
  "

  log.section "Run simulation"
  sim.perform "101 101 1.e5 -1"

  log.section "Simulation results"
  sh "cat #{current_run_path}/ppc.log |grep photons |grep hits"
end

desc "Shoot photons from flasher towards a DOM with varying hole-ice radius"
task :firing_range_with_varying_hole_ice_radius => :setup do
  %w(0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0).each do |hole_ice_radius|
    @current_sub_run = "with_hole_ice_radius_#{hole_ice_radius}"

    sim = PpcSimulation.new(directory: current_sub_run_path)

    sim.write_configuration_file "cfg.txt", "
      # ppc configuration file: follow strict order below
      1     # over-R: DOM radius 'oversize' scaling factor
      1.0   # overall DOM efficiency correction
      0.35  # 0=HG; 1=SAM
      0.9   # g=<cos(theta)>
      
      130.0 # azimuth of major anisotropy axis (deg)
      0.0   # magnitude of major anisotropy coefficient k1
      0.0   # magnitude of minor anisotropy coefficient k2
      
      #{hole_ice_radius}   # hole ice radius in units of [DOM radius]
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

    sim.configure_geometry "
      TP6P1297 0x5144dd0bba6c -66.7074 276.892 -1773.64 101 101
      TP6P1297 0x5144dd0bba6c -67.7074 276.892 -1773.64 102 101
    "

    benchmark = Benchmark.measure do
      sim.perform "101 101 1.e6 -1"
    end
    
    sh "cat #{current_sub_run_path}/ppc.log |grep photons |grep hits"
    number_of_hits = `cat #{current_sub_run_path}/hits.txt |grep "102 101"`.split("\n").count
    File.open("#{current_run_path}/hits.txt", 'a') { |file| file << "#{hole_ice_radius} #{number_of_hits}\n" }

    execution_time = benchmark.real
    File.open("#{current_run_path}/benchmark.txt", 'a') { |file| file << "#{hole_ice_radius} #{execution_time}\n" }
  end

  shell "scripts/plot_number_of_hits_vs_hole_ice_radius.py #{current_run_path}"
  log.success "#{current_run_path}/hits.png"

  shell "scripts/plot_execution_time_vs_hole_ice_radius.py #{current_run_path}"
  log.success "#{current_run_path}/benchmark.png"
end

task :angular_acceptance_scan => :create_run
