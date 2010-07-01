#!/bin/sh
#
# this script handles the btpd daemon process

# ====== UTILITY FUNCTION BEGINNING ======

# Set up a default search path.
PATH="/sbin:/usr/sbin:/bin:/usr/bin"
export PATH

# Check if $pid (could be plural) are running
checkpid() {
	local i

	for i in $* ; do
		[ -d "/proc/$i" ] && return 0
	done
	return 1
}

# __proc_pids {program} [pidfile]
# Set $pid to pids from /var/run* for {program}.  $pid should be declared
# local in the caller.
# Returns LSB exit code for the 'status' action.
__pids_var_run() {
	local base=${1##*/}
	local pid_file=${2:-/var/run/$base.pid}

	pid=
	if [ -f "$pid_file" ] ; then
	        local line p
		read line < "$pid_file"
		for p in $line ; do
			[ -d "/proc/$p" ] && pid="$pid $p"
		done
	        if [ -n "$pid" ]; then
	                return 0
	        fi
		return 1 # "Program is dead and /var/run pid file exists"
	fi
	return 3 # "Program is not running"
}

# Output PIDs of matching processes, found using pidof
__pids_pidof() {
	pidof "$1"
}

# A function to stop a program.
killproc() {
	local RC killlevel= base pid pid_file= delay

	RC=0; delay=3
	# Test syntax.
	if [ "$#" -eq 0 ]; then
		echo $"Usage: killproc [-p pidfile] [ -d delay] {program} [-signal]"
		return 1
	fi
	if [ "$1" = "-p" ]; then
		pid_file=$2
		shift 2
	fi
	if [ "$1" = "-d" ]; then
		delay=$2
		shift 2
	fi
        

	# check for second arg to be kill level
	[ -n "${2:-}" ] && killlevel=$2

        # Save basename.
        base=${1##*/}

        # Find pid.
	__pids_var_run "$1" "$pid_file"
	if [ -z "$pid_file" -a -z "$pid" ]; then
		pid="$(__pids_pidof "$1")"
	fi

        # Kill it.
        if [ -n "$pid" ] ; then
                [ "$BOOTUP" = "verbose" -a -z "${LSB:-}" ] && echo -n "$base "
		if [ -z "$killlevel" ] ; then
		       if checkpid $pid 2>&1; then
			   # TERM first, then KILL if not dead
			   kill -TERM $pid >/dev/null 2>&1
			   usleep 100000
			   if checkpid $pid && sleep 1 &&
			      checkpid $pid && sleep $delay &&
			      checkpid $pid ; then
                                kill -KILL $pid >/dev/null 2>&1
				usleep 100000
			   fi
		        fi
			checkpid $pid
			RC=$?
			[ "$RC" -eq 0 ] && failure $"$base shutdown" || success $"$base shutdown"
			RC=$((! $RC))
		# use specified level only
		else
		        if checkpid $pid; then
	                	kill $killlevel $pid >/dev/null 2>&1
				RC=$?
				[ "$RC" -eq 0 ] && success $"$base $killlevel" || failure $"$base $killlevel"
			elif [ -n "${LSB:-}" ]; then
				RC=7 # Program is not running
			fi
		fi
	else
		if [ -n "${LSB:-}" -a -n "$killlevel" ]; then
			RC=7 # Program is not running
		else
			failure $"$base shutdown"
			RC=0
		fi
	fi

        # Remove pid file if any.
	if [ -z "$killlevel" ]; then
            rm -f "${pid_file:-/var/run/$base.pid}"
	fi
	return $RC
}

# Log that something succeeded
success() {
  return 0
}

# Log that something failed
failure() {
  local rc=$?
  return $rc
}

# ====== UTILITY FUNCTION END ======


btpd_start(){
#define where bthome is. This is where btpd stores metadata information
#such as how many torrents are being downloaded and their progress
    
    disk=$1
    
    bthome=$disk/btpd
    btdownload=$disk/btdownload

#define where the btpd binary is
    btpdbin=/usr/local/bin/btpd

		if [ ! -d $disk ]; then
			echo "disk directory is invalid"
			exit 1
		fi

    if [ ! -d $bthome ]; then
			mkdir $bthome
    fi
    
   if [ ! -d $btdownload ]; then
			mkdir $btdownload
    fi

		echo $btdownload > /usr/local/etc/dvdplayer/.btpath

    if [ ! -e $btpdbin ]; then
			echo "btpd binary is missing"
			exit 1
    fi

#start running btpd
    HOME=$bthome
    $btpdbin

	#/usr/local/bin/unicgi start

   # return 0;
	exit 0;
}

btpd_stop(){
		disk=$1
    btpidf=$disk/btpd/.info/pid
    killproc -p $btpidf	
	exit 0;
}

btpd_status(){
		disk=$1
    btpidf=$disk/btpd/.info/pid

    if [ ! -e $btpidf ]; then
	echo "btpd stopped..."
	exit 0
    fi

    btpid=`cat $btpidf`
    pattern1=`ps | grep $btpid`
    pattern2=`echo $pattern1 | grep btpd`

    if test "$pattern2" == ""; then 
	echo "btpd stopped"
	exit 0
    fi
    echo "btpd running"
    exit 0
}

case "$1" in
	start)
		btpd_start $2
		;;
	stop)
		btpd_stop $2
		;;
	status)
		btpd_status $2
		;;
	*)
      	echo $"Usage: $0 {start|stop|status}"
		exit 1
esac

exit 1
