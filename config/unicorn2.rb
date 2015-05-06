APP_ROOT = File.expand_path(File.dirname(File.dirname(__FILE__)))

# Set the working application directory
# working_directory "/path/to/your/app"
#working_directory "/home/ec2-user/Profectus/"

# Unicorn PID file location
# pid "/path/to/pids/unicorn.pid"
#pid "/home/ec2-user/Profectus/pids/unicorn.pid"

# Path to logs
# stderr_path "/path/to/log/unicorn.log"
# stdout_path "/path/to/log/unicorn.log"
#stderr_path "/home/ec2-user/Profectus/log/unicorn.log"
#stdout_path "/home/ec2-user/Profectus/log/unicorn.log"

# Unicorn socket
#listen "/tmp/unicorn.[app name].sock"
#listen "/tmp/unicorn.myapp.sock"

# Number of processes
# worker_processes 4
worker_processes 8

# Time-out
timeout 30

require APP_ROOT + '/config/roundScript.rb'
after_fork do |server, worker|
	roundScript() if worker.nr == 0
end