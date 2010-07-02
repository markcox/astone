To create your firmware, cd to the directory containing build.sh and type

./build.sh make

This is how build.sh works. When you run build.sh with the make option
it will clean all the leftover files in the FINAL-IMAGE and staging
directories to ensure a clean build. For this reason it is a good
idea to store install.img in a different location if you want to
keep it. After the cleanup, build.sh will copy all files in the 
directory corresponding to the player model and version 
(eg ap110d-1.90) to the staging directory and start building
the firmware image using these files. The final image generated is
install.img and will be placed in directory FINAL-IMAGE. 

If you want to edit files and have them included in the firmware,
you need to do so in the directory corresponding to your player
model (eg ap110d-1.90). The directory of interest is package1 for
squashfs players such as Astone, or package2 for yaffs2 players such
as the Patriot Box.

To pull the latest svn repository, see this link:
http://code.google.com/p/astone/source/checkout

You need to have svn installed of course. The build should work
with Debian Lenny.

You can browse the repository with your web browser too. Just
go to this link:
http://astone.googlecode.com/svn/trunk/


