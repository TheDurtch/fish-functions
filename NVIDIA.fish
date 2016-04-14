function NVIDIA

set CPU_COUNT (math (cat /proc/cpuinfo | grep processor | wc -l)+1)
set USER_GROUP (echo (id -u -n):(id -g -n))
echo "Initilize sudo"
sudo echo "sudo initilized"

cd /kernel-update-stuff/

curl -s http://www.nvidia.com/object/linux-amd64-display-archive.html > /kernel-update-stuff/tmp/NVIDIA_LINUX_SOUCE_HTML

set nvidiachangelogurl1 (cat /kernel-update-stuff/tmp/NVIDIA_LINUX_SOUCE_HTML | grep "Download/" | sed -n '3p' | cut -d '"' -f4)
set nvidiachangelogurl2 (cat /kernel-update-stuff/tmp/NVIDIA_LINUX_SOUCE_HTML | grep "Download/" | sed -n '4p' | cut -d '"' -f4)
set nvidiachangelogurl3 (cat /kernel-update-stuff/tmp/NVIDIA_LINUX_SOUCE_HTML | grep "Download/" | sed -n '5p' | cut -d '"' -f4)
curl -s $nvidiachangelogurl1 > /kernel-update-stuff/tmp/NVIDIA_LINUX_LOG1
curl -s $nvidiachangelogurl2 > /kernel-update-stuff/tmp/NVIDIA_LINUX_LOG2
curl -s $nvidiachangelogurl3 > /kernel-update-stuff/tmp/NVIDIA_LINUX_LOG3

set nvidiaver1 (cat /kernel-update-stuff/tmp/NVIDIA_LINUX_LOG1 | html2text -utf8 | grep "Version" |cut -d ' ' -f11| cut -d ' ' -f1)
set nvidiaver2 (cat /kernel-update-stuff/tmp/NVIDIA_LINUX_LOG2 | html2text -utf8 | grep "Version" |cut -d ' ' -f11| cut -d ' ' -f1)
set nvidiaver3 (cat /kernel-update-stuff/tmp/NVIDIA_LINUX_LOG3 | html2text -utf8 | grep "Version" |cut -d ' ' -f11| cut -d ' ' -f1)
cd /kernel-update-stuff/nvidia-drivers/
set nvidiaver0 (ls -la | awk '{print $9}' | grep NVIDIA-Linux-x86_64 | cut -d "-" -f4|cut -d "." -f1-2)
echo "You have versions $nvidiaver1, $nvidiaver2, and $nvidiaver3 available online.
You have version $nvidiaver0 on your computer already.
Would you like to check the changelogs for any of the online versions?
"
echo "Enter 0 if you want don't need to see the changelog"
echo "Enter 1 if you want to view the changelog for version $nvidiaver1"
echo "Enter 2 if you want to view the changelog for version $nvidiaver2"
echo "Enter 3 if you want to view the changelog for version $nvidiaver3"
read prompt2
if [ "$prompt2" = "1" ]
echo $nvidiachangelogurl1
cat /kernel-update-stuff/tmp/NVIDIA_LINUX_LOG1 | grep '<ul><li>' | html2text -utf8
end

if [ "$prompt2" = "2" ]
echo $nvidiachangelogurl2
cat /kernel-update-stuff/tmp/NVIDIA_LINUX_LOG2 | grep '<ul><li>' | html2text -utf8
end

if [ "$prompt2" = "3" ]
echo $nvidiachangelogurl3
cat /kernel-update-stuff/tmp/NVIDIA_LINUX_LOG3 | grep '<ul><li>' | html2text -utf8
end

if [ "$prompt2" = "0" ]
echo "Oh I see how it is...
well then..."
end

echo "Enter 0 if you $nvidiaver0 is the latest version"
echo "Enter 1 if you want $nvidiaver1"
echo "Enter 2 if you want $nvidiaver2"
echo "Enter 3 if you want $nvidiaver3"
echo "Enter 9 if you don't want to do anything"
read prompt3


if [ "$download_NV" = "1" ]
curl http://us.download.nvidia.com/XFree86/Linux-x86_64/$nvidiaver/NVIDIA-Linux-x86_64-$nvidiaver.run -o NVIDIA-Linux-x86_64-$nvidiaver.run
end

if [ "$download_NV" = "0" ]
end

sudo sh NVIDIA-Linux-x86_64-$nvidiaver.run -a --no-questions --disable-nouveau --run-nvidia-xconfig --concurrency-level=$CPU_COUNT #-s
rm /kernel-update-stuff/tmp/*
sudo mkinitrd
sudo nvidia-modprobe
sudo init 5
end

