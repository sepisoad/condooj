# Condooj
---

Condooj is a lightweight and small command line based password manager. It is supposed to be portable, eventually the code will be compiled on all major OSes. since it is written in nim language it isn't a hard thing to acheive. Currently Ubuntu linux is the only tested OS since I'm developing this application under Ubuntu.

The code is licensed under GPLv3 license.

You need to know that the application is a work in progress and there is a big list of missing features. but for now it can manage to do following stuff:

  - add a new login record 
  - update an existing login record
  - delete an existing login record
  - list all existing login records
 
##bellow is the list of missing features:
  - random password generator
  - login records encryption and decryption when saving and loading from disk 
  - put login records on dropbox for syncing and backup purpose

##Version
0.0.1

##How to compile
the application is almost entirely written in [nim](http://nim-lang.org/) language
under ubuntu all you need to do is to get the latest nim lang and compile it
and then run 'build.sh' file it will then generate and file named condooj under src folder 
which you can run it from everywhere.

##Contact me
sepehr.aryani@gmail.com 

i'm also on twitter @sepisoad, i check my twitter frequently and will reply quickly
cheers ;)
