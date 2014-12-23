worker_processes 4

# TODO: Check if /run/puppet exists if SysVinit script was never run
listen "/run/puppet/puppetmaster.sock", :backlog => 512
pid "/run/puppet/puppetmaster.pid"

timeout 120

# TODO: Check if master could be started as puppet use by systemd
user 'puppet'

preload_app true

# TODO: Reload not working, no access or missing HOME
before_fork do |server, worker|
  old_pid = "#{server.config[:pid]}.oldbin"
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end
end
