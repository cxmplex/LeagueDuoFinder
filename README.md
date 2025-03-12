# LeagueDuoFinder
Finds Duo'd Players in live games using OP.GG

# Usage
Running the program:

This program requires Perl and the modules WWW::Mechanize & Switch.

Start the program by opening a command prompt in the current directory. Type 'perl LoLWrapper.pl' to launch the application.

When the program first starts, it will ask you to create a config file. This is all done within the application itself. If you'd like to change your config at any time, the format is: 

REGION

SUMMONER

Alternatively, you can delete the file and restart the program.

# Known Bugs / Issues

Prints out both matches (ie player 1 is playing with player 2, player 2 is playing with player 1)

No region support besides NA. I will add this later, but non-NA regions have special characters that I haven't attempted to support yet.

OP.GG Refresh support. I will add this in the future.
