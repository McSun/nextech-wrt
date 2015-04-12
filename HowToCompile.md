# Introduction #

This document will give you basic instructions on how to compile the Tomato firmware along with our modified Web GUI. A basic knowledge of Linux is required. These instructions are assuming a Debian distro (Damn Small Linux, Knoppix, Ubuntu, etc). If you are using a different distro you may need to use slightly different commands or path names.

# Installing Linux #

If you already have a Linux machine ready, skip to the next section.

I use VMware Fusion to run a virtual machine running Debian Linux. My virtual machine has a 10gb virtual hard drive with its space not all allocated at once, and 512 mb of RAM. Download the [TinyCD stable Debian](http://ftp.acc.umu.se/debian-cd/5.0.1/i386/iso-cd/debian-501-i386-netinst.iso) and install only a Standard System.

# Downloading the necessary files #

Install the necessary compilers and other tools for Debian. If you are using a different distribution, you will need to install these tools in some other way. In the following commands replace _YOUR-USERNAME_ with the username you setup and are logged in as.
```
su -c "apt-get update;apt-get install sudo openssh-server subversion;echo 'YOUR-USERNAME  ALL=(ALL) ALL' >> /etc/sudoers" 
```
At this point you can SSH into your virtual machine. I like to do this because I can copy and paste into Terminal, thus saving lots of typing.
```
ssh YOUR-USERNAME@virtualmachineIP
```
Once you have SSH'd in, continue installing build tools.
```
sudo apt-get install gcc g++ binutils patch bzip2 flex bison make gettext unzip zlib1g-dev 
sudo apt-get install libc6 libncurses5-dev libstdc++5 automake automake1.7 automake1.9 openssl
```
Next, download the firmware source and untar it into your home directory. I have already prepared the source code and am hosting it on my web server. It is 179 megs and may take a while to download depending on your connection speed.
```
cd ~
wget http://jeffbaier.com/school/capstone/tomato_src.tgz
tar zxvf tomato_src.tgz
```
Now we need to replace the stock firmware files with the ones we have modified. We will be downloading the latest code from our subversion repository.

First remove the existing www and nvram folders.
```
 cd ~/tomato/release/src/router/
 rm -rf www nvram
```
Then download the modified ones from SVN.
```
 svn checkout http://nextech-wrt.googlecode.com/svn/trunk .
```


# Configure and Compile #
Now we need to create a symbolic link from the cross compiler to the /opt/brcm directory and add it to the environment PATH. This will only take affect when you next login, so also set the PATH variable now.
```
sudo ln -s ~/tomato/tools/brcm/ /opt/brcm
echo 'PATH=$PATH:/opt/brcm/hndtools-mipsel-uclibc/bin:/opt/brcm/hndtools-mipsel-linux/bin' >> ~/.bash_profile
echo 'export PATH' >> ~/.bash_profile
PATH=$PATH:/opt/brcm/hndtools-mipsel-uclibc/bin:/opt/brcm/hndtools-mipsel-linux/bin
```
Everything is ready now. Change into the appropriate directory and start compiling.
```
cd ~/tomato/release/src/
make
```
If there were no problems, you will now have several different firmware images in your _~/tomato/release/src/image/_ directory. You will only need the one named _WRT54G\_WRT54GL.bin_.

# Update and Re-compile #
Once changes are made to the web gui and they have been committed to the SVN repository, simply run the following commands to download the new source code and recompile.
```
cd ~/tomato/release/src/router/
svn update
cd ..
make clean
make
```

# Troubleshooting #
If you have any problems, contact Jeff Baier. Email address, phone number, and IM information is available in our Capstone shared Google Doc. Once we resolve the problem, I'll put the solution here so that it may help others in the future.