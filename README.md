# open-ice

This was a very clean drop of code and did not take too much work to get it to (cleanly) compile.
I did not extensively test the end product 1.21 rom this builds. 
It could be bug-ridden. the INC files state this is not a final product. 
I did not dig into this a lot, i am more of a Jam/Hangtime fan. (for which we lack the preasm.exe..)

# notes

All items in the CODE folder are already setup to run make -m :)

Set up Dosbox/path etc. Then from dosbox run :
cd CODE
make -m (repeat as needed / if it errors out.)
copy hh.out ..
makeroms.bat (from a real win32 CMD prompt.)

Alternatively if you keep getting annoyed by make, use 

http://www.shdon.com/blog/2009/09/05/adjustable-files-setting-in-dosbox

You need all the tools from TI in the path + midway stuff like SREC.EXE and LOAD2.EXE.
go.bat in IMG folder creates the TBL stuff. Needs c:\tmp. I think one ASM file builds wrong for some reason.
It was included in the src so i copied it over and this fixes it.

dosbox requires repeatedly running make -m to build hh.out finally..

Note: dosbox does not like makeroms.bat so the final copy/b merge should be done a real machine, or in win32 CMD prompt.

End result is:

open_ice_l1.21.u54
open_ice_l1.21.u63

Enjoy!
