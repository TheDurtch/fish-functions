function netatop

set CPU_COUNT (math (cat /proc/cpuinfo | grep processor | wc -l)+1)
set USER_GROUP (echo (id -u -n):(id -g -n))
echo "Initilize sudo"
sudo echo "sudo initilized"

cd /kernel-update-stuff/

curl -s http://www.atoptool.nl/downloadnetatop.php > /kernel-update-stuff/tmp/NETATOP_LINUX_SOURCE_HTML
set natopver1 (cat /kernel-update-stuff/tmp/NETATOP_LINUX_SOURCE_HTML | grep "netatop-0...tar.gz" | sed -n '1p' | cut -d '"' -f2 | cut -d "." -f1-2 | cut -d "/" -f2)
set natopver2 (cat /kernel-update-stuff/tmp/NETATOP_LINUX_SOURCE_HTML | grep "netatop-0...tar.gz" | sed -n '2p' | cut -d '"' -f2 | cut -d "." -f1-2 | cut -d "/" -f2)
set natopver3 (cat /kernel-update-stuff/tmp/NETATOP_LINUX_SOURCE_HTML | grep "netatop-0...tar.gz" | sed -n '3p' | cut -d '"' -f2 | cut -d "." -f1-2 | cut -d "/" -f2)
set natopver0 (ls -la | awk '{print $9}' | grep netatop)
echo "Enter 1 if you want $natopver1"
echo "Enter 2 if you want $natopver2"
echo "Enter 3 if you want $natopver3"
echo "Enter 0 if $natopver0 is the latest version"
read prompt1

#############################
if [ "$prompt1" = "1" ]
set natopver $natopver1
set download_ATOP 1
end

if [ "$prompt1" = "2" ]
set natopver $natopver2
set download_ATOP 1
end

if [ "$prompt1" = "3" ]
set natopver $natopver3
set download_ATOP 1
end

if [ "$prompt1" = "0" ]
set natopver $natopver0
set download_ATOP 0
end

if [ "$download_ATOP" = "1" ]
mv -rf $natopver0/ old/
curl http://www.atoptool.nl/download/$natopver.tar.gz | tar xzf -
end
if [ "$download_ATOP" = "0" ]
end
sudo chown -Rc $USER_GROUP $natopver
cd /kernel-update-stuff/$natopver
make clean
make -j$CPU_COUNT
sudo make install
