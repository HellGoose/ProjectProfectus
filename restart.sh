#!/bin/sh
unicorn_pid=`cat pids/unicorn.pid`
echo "Restarting Unicorn ($unicorn_pid)"
kill -HUP $unicorn_pid