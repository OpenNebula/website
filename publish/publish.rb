#!/usr/bin/ruby

require 'date'
require 'fileutils'
require 'open3'
require 'yaml'

# ------------------------------------------------------------------------------
# Helpers
# ------------------------------------------------------------------------------
# Run a command
#
# @param cmd [String] Command to run
def run(cmd)
    rtn = nil

    Open3.popen3(cmd) do |_, o, e, t|
        out_reader = Thread.new { o.read }
        err_reader = Thread.new { e.read }

        rtn = [out_reader.value, err_reader.value, t.value]
    end

    rtn
end

# Print error and exit
#
# @param rc [Array] rc[0] STDOUT rc[1] STDERR
def error(rc)
    return rc[0].strip if rc[2].success?

    puts "ERROR: #{rc[1]}"

    exit(-1)
end
# ------------------------------------------------------------------------------
# load config
# ------------------------------------------------------------------------------

config = YAML.load_file('publish/config.yaml')

branch = ARGV[0]
unless config['mapping'].include?(branch)
  puts "Aborting, branch '#{branch}' is not published"
  exit(0)
end

# ------------------------------------------------------------------------------
# Read secrets from ENV
# ------------------------------------------------------------------------------
host      = ENV['HOST']
host_path = ENV['HOST_PATH']

branch_dir = config['mapping'][branch]
ssh_op     = '-o StrictHostKeyChecking=no -i /tmp/id_rsa'

# Ensure dir base exist
error(run("ssh #{ssh_op} #{host} 'test -d #{host_path} && touch #{host_path}'"))

# ------------------------------------------------------------------------------
# Devel branch
# ------------------------------------------------------------------------------

if branch_dir == 'devel'
  puts "[INFO] Deploying to 'devel' folder (no symlinks/timestamp)"

  # Remove old folder if exist
  error(run("ssh #{ssh_op} #{host} 'rm -rf #{host_path}/devel'"))

  # Creates a new devel folder
  error(run("ssh #{ssh_op} #{host} 'mkdir -p #{host_path}/devel'"))

  # Copy/publish the new website content
  error(run("tar -C './public/' --mode='a+r' -cf - . | " \
            "ssh #{ssh_op} #{host} 'tar -C #{host_path}/devel -xvf -'"))

  exit(0)
end

# ------------------------------------------------------------------------------
# Versioned branch
# ------------------------------------------------------------------------------

date_time           = DateTime.now.strftime('%Y%m%d%H%M%S')
branch_symlink_path = "#{host_path}/#{branch_dir}"
branch_build_path   = "#{branch_symlink_path}.#{date_time}"


# creates new versioned dir
error(run("ssh #{ssh_op} #{host} 'mkdir #{branch_build_path}'"))

# copy/publish the website content
error(run("tar -C './public/' --mode='a+r' -cf - . | " \
          "ssh #{ssh_op} #{host} 'tar -C '#{branch_build_path}' -xvf -'"))

# update the symlink
error(
    run(
        "ssh #{ssh_op} #{host} " \
        "'ln -nsf #{branch_dir}.#{date_time} #{branch_symlink_path}'"
    )
)

# ensure dir exists
rc = run("ssh #{ssh_op} #{host} 'ls #{host_path} | grep #{branch_dir}. | sort'")
error(rc)

# ensure branch_symlink_path exists
rc = run("ssh #{ssh_op} #{host} 'test -e #{branch_symlink_path} || " <<
             " echo \"#{branch_symlink_path} does not exists\" >&2'")
error(rc)

# ensure branch_symlink_path is a symlink
rc = run("ssh #{ssh_op} #{host} 'test -L #{branch_symlink_path} || " <<
             " echo \"#{branch_symlink_path} is not a symlink\" >&2'")
error(rc)

# cleanup old versions

rc = run("ssh #{ssh_op} #{host} 'find #{host_path} -maxdepth 1 -type d -name \"#{branch_dir}.*\" -printf \"%f\\n\" | sort'")
error(rc)

builds = rc[0].split

puts "Total builds found: #{builds.length}"
puts "Builds: #{builds.join("\n")}"

exit(0) if builds.length <= 2

# List all builds except the two most recent
old_builds = builds[0...-2]
old_builds.each do |build|
  puts "Removing old build folder: #{build}"
  run("ssh #{ssh_op} #{host} rm -rf #{host_path}/#{build}")
end
