function post-kernel-update
set CPU_COUNT (math (cat /proc/cpuinfo | grep processor | wc -l)+1)
echo "Initilize sudo"
sudo echo "sudo initilized"
cd /kernel-update-stuff/
set natopver1 (curl -s http://www.atoptool.nl/downloadnetatop.php  | grep "netatop-0...tar.gz" | sed -n '1p' | cut -d '"' -f2 | cut -d "." -f1-2 | cut -d "/" -f2)
set natopver2 (curl -s http://www.atoptool.nl/downloadnetatop.php  | grep "netatop-0...tar.gz" | sed -n '2p' | cut -d '"' -f2 | cut -d "." -f1-2 | cut -d "/" -f2)
set natopver3 (curl -s http://www.atoptool.nl/downloadnetatop.php  | grep "netatop-0...tar.gz" | sed -n '3p' | cut -d '"' -f2 | cut -d "." -f1-2 | cut -d "/" -f2)
set natopver0 (ls -la | awk '{print $9}' | grep netatop)
echo "Enter 1 if you want $natopver1"
echo "Enter 2 if you want $natopver2"
echo "Enter 3 if you want $natopver3"
echo "Enter 0 if $natopver0 is the latest version"
read prompt1
if [ "$prompt1" = "1" ]
set natopver $natopver1
mv -rf $natopver0/ old/
curl http://www.atoptool.nl/download/$natopver.tar.gz | tar xzf -
end
if [ "$prompt1" = "2" ]
set natopver $natopver2
mv -rf $natopver0/ old/
curl http://www.atoptool.nl/download/$natopver.tar.gz | tar xzf -
end
if [ "$prompt1" = "3" ]
set natopver $natopver3
mv -rf $natopver0/ old/
curl http://www.atoptool.nl/download/$natopver.tar.gz | tar xzf -
end
if [ "$prompt1" = "0" ]
set natopver $natopver0
end
sudo chown -Rc kate:users $natopver
cd /kernel-update-stuff/$natopver
make -j$CPU_COUNT
sudo make install
cd /kernel-update-stuff/nvidia-drivers/
curl -s http://www.nvidia.com/object/linux-amd64-display-archive.html > /tmpfs/NVIDIA_LINUX_SOUCE_HTML
set nvidiaver1 (cat /tmpfs/NVIDIA_LINUX_SOUCE_HTML | grep "Download/" | sed -n '3p' | cut -d ':' -f3 | cut -d ' ' -f2 | cut -d '<' -f1)
set nvidiachangelogurl1 (cat /tmpfs/NVIDIA_LINUX_SOUCE_HTML | grep "Download/" | sed -n '3p' | cut -d '"' -f4)
set nvidiaver2 (cat /tmpfs/NVIDIA_LINUX_SOUCE_HTML | grep "Download/" | sed -n '4p' | cut -d ':' -f3 | cut -d ' ' -f2 | cut -d '<' -f1)
set nvidiachangelogurl2 (cat /tmpfs/NVIDIA_LINUX_SOUCE_HTML | grep "Download/" | sed -n '4p' | cut -d '"' -f4)
set nvidiaver3 (cat /tmpfs/NVIDIA_LINUX_SOUCE_HTML | grep "Download/" | sed -n '5p' | cut -d ':' -f3 | cut -d ' ' -f2 | cut -d '<' -f1)
set nvidiachangelogurl3 (cat /tmpfs/NVIDIA_LINUX_SOUCE_HTML | grep "Download/" | sed -n '5p' | cut -d '"' -f4)
set nvidiaver0 (ls -la | awk '{print $9}' | grep NVIDIA-Linux-x86_64 | cut -d "-" -f4|cut -d "." -f1-2)
echo "You have versions $nvidiaver1, $nvidiaver2, and $nvidiaver3 available online.
You have version $nvidiaver0 on your computer already.
Would you like to check the changelogs for any of the online versions?
"
echo "Enter 0 if you want don't need to see the changelog"
echo "Enter 1 if you want to view the changelog for version $nvidiaver1"
echo "Enter 2 if you want to view the changelog for version $nvidiaver2"
echo "Enter 3 if you want to view the changelog for version $nvidiaver3"

read prompt1
if [ "$prompt1" = "1" ]
echo $nvidiachangelogurl1
curl -s $nvidiachangelogurl1 | grep 'ul type="disc"' | html2text -utf8
end
if [ "$prompt1" = "2" ]
echo $nvidiachangelogurl2
curl -s $nvidiachangelogurl2 | grep 'ul type="disc"' | html2text -utf8
end
if [ "$prompt1" = "3" ]
echo $nvidiachangelogurl3
curl -s $nvidiachangelogurl3 | grep 'ul type="disc"' | html2text -utf8
end
if [ "$prompt1" = "0" ]
echo "Oh I see how it is...
well then..."
end

echo "Enter 0 if you $nvidiaver0 is the latest version"
echo "Enter 1 if you want $nvidiaver1"
echo "Enter 2 if you want $nvidiaver2"
echo "Enter 3 if you want $nvidiaver3"
echo "Enter 9 if you don't want to do anything"
read prompt1
if [ "$prompt1" = "1" ]
set nvidiaver $nvidiaver1
mv -f NVIDIA-Linux-x86_64-$nvidiaver0.run ../old/
curl http://us.download.nvidia.com/XFree86/Linux-x86_64/$nvidiaver/NVIDIA-Linux-x86_64-$nvidiaver.run -o NVIDIA-Linux-x86_64-$nvidiaver.run
end
if [ "$prompt1" = "2" ]
set nvidiaver $nvidiaver2
curl http://us.download.nvidia.com/XFree86/Linux-x86_64/$nvidiaver/NVIDIA-Linux-x86_64-$nvidiaver.run -o NVIDIA-Linux-x86_64-$nvidiaver.run
end
if [ "$prompt1" = "3" ]
set nvidiaver $nvidiaver3
curl http://us.download.nvidia.com/XFree86/Linux-x86_64/$nvidiaver/NVIDIA-Linux-x86_64-$nvidiaver.run -o NVIDIA-Linux-x86_64-$nvidiaver.run
end
if [ "$prompt1" = "0" ]
set nvidiaver (ls -la | awk '{print $9}' | grep NVIDIA-Linux-x86_64 | cut -d "-" -f4|cut -d "." -f1-2)
end
if [ "$prompt1" = "9" ]
echo "Oh is this only a test??
Ok I'll just kill this script then.
It's not like I wanted to run or anything" | randtype -m 4
exit 0
end
sudo sh NVIDIA-Linux-x86_64-$nvidiaver.run -a --no-questions --disable-nouveau --run-nvidia-xconfig --concurrency-level=$CPU_COUNT #-s
sudo mkinitrd
sudo nvidia-modprobe
sudo init 5
end
