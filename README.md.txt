# Condooj

Condooj is a lightweight and small command line based password manager. It is supposed to be portable and eventually will be compiled on all major OSes. It isn't a hard thing to achieve due to the fact that the code is almost entirely written in [nim](http://nim-lang.org/) language. Though currently Ubuntu linux is the only tested OS since I'm developing this application under Ubuntu.

The code is licensed under GPLv3 license.

You need to know that the application is a work in progress and there is a big list of missing features. but for now it can manage to do following stuff:

  - add a new login record 
  - update an existing login record
  - delete an existing login record
  - list all existing login records
  - user can see an specific login record
  - login records are encrypted using a passphrase as a key before saving into disk 
  - random password generator
 
##bellow is the list of missing features:
  - putting login records on dropbox for syncing and backup purpose
  - Improving cli command input and options
  - improve login record encryption (it seems to be week)

##Version
0.0.1

##How to compile
all you need to do is to get the latest version of nim compiler and compile it and then use 'nakefile' with 'debug' or 'release' option to build the source code.

##Contact me
email: [sepehr.aryani@gmail.com](sepehr.aryani@gmail.com)
twitter: [@sepisoad](https://twitter.com/sepisoad)
github: [@sepisoad](https://github.com/sepisoad)