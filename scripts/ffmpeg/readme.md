sudo cp vconv* /usr/local/bin/
sudo chmod 755 /usr/local/bin/vconv*
sudo cp rip* /usr/local/bin/
sudo chmod 755 /usr/local/bin/rip*
sudo cp imdb.sh /usr/local/bin/

sudo cp vconv-ripcapt.sh /usr/local/bin/
sudo chmod 755 /usr/local/bin/vconv-ripcapt.sh


scp /home/apham/workspaces/debian-os-image/scripts/ffmpeg/bmtv.sh fujb:/home/apham

cd /usr/local/bin/
sudo wget http://192.168.8.100:8787/blackmagic/ffmpeg
sudo wget http://192.168.8.100:8787/blackmagic/ffprobe

sudo chmod 755 ffmpeg
sudo chmod 755 ffprobe