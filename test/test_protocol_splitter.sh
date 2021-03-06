#open QGroundcontrol connection with 'Target Host: 127.0.0.1:5800'
#start PX4 + Gazebo: make px4_sitl_rtps gazebo_solo


if [ ! -e /dev/vcom_px4 ]; then
	echo "Start VCOM link"
	sudo socat PTY,link=/dev/vcom_dds,raw,echo=0 PTY,link=/dev/vcom_px4,raw,echo=0 &
	sleep 3
	echo "Enable read access"
	ddslink=$(readlink -f /dev/vcom_dds)
	px4link=$(readlink -f /dev/vcom_px4)
	sudo chmod +r $ddslink $px4link
else
	echo "VCOM link active"
fi

echo "start protocol splitter - PX4 end, listen to PX4 mavlink port #0"
../build/protocol_splitter -d /dev/vcom_px4 -w 14550 -x 18570 -y 14900 -z 14901 &
echo "start protocol splitter - DDS end"
../build/protocol_splitter -d /dev/vcom_dds -w 15517 -x 15518 -y 15900 -z 15901 &

#echo "start Mavlink message listener - DDS end"
#./mavlink_reader.py --ip 127.0.0.1 --port 12345
