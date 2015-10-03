# Fruit Tap data
## Source
These data were collected as part of The Great Brain Experiment. The data presented here are from the game 'Fruit Tap' or 'How Impulsive Am I?' A total of 71981 sessions (i.e. sets of 32 trials) were collected between March 11th 2012 and April 3rd 2014 from 29740 participants.
## Format
The data are stored as a single Matlab struct variable. Each element of the struct (e.g. dat(1)) represents a single participant.
To load this struct using Python's scipy package see [here](http://docs.scipy.org/doc/scipy/reference/tutorial/io.html#matlab-structs).
## Attributes in the datafile
Each element of the struct has the following fields (n indicates number of games stored for that user). Note that data are sent to our servers only upon completion of a minigame. If no connection was available those data are lost forever.
* age             string                          one of 7 age ranges
* gender          string                          male/female
* education       string                          one of 4 levels of attained education
* devicetype      string                          'iOS' or 'other'. iOS includes iPod, iPad, iPhone. Abstracted from more specific info to retain privacy
* appversion      string or NaN                   Can be one of '1-0', '2-0', '01/04/2014', '01/02/2014'. Important for interpreting the first column of dat.data
* timesPlayed     1 x n array                     how many times the user had *initiated* a Fruit Tap game at the time of submission of each block (e.g. if this array is [1 3], then the second game was initiated but never sent to our servers)
* timesubmitted   cell array of strings           each cell contains a datestamp (dd/mm/yyyy) indicating when the record was received
* data            cell array of matrices          each element contains a 32-by-7 matrix.
## Data columns
1. In version 1, 0: trial was 'Unprepared'; 1: 'Prepared' but unknown which side was 'glowing'. In version >1, 0: trial was 'Unprepared'; 2: left fruit was 'glowing'; 3: right fruit was 'glowing'.
2. 0: Go trial, neither fruit went bad; 1: Strop trial, fruit on right side went bad; 2: Stop trial, fruit on left side went bad
3. number of milliseconds between the fruit turning bad and *the center point of the reaction time window* (which is at 650 ms after the fruit starts falling)
4. number of milliseconds between the fruit starting to fall, and the first time the user pressed the **left** side of the screen
5. number of milliseconds between the fruit starting to fall, and the first time the user pressed the **right** side of the screen
6. number of milliseconds between the 'Get ready!' message and the fruit starting to fall
7. whether or not the player successfully completed the trial (successful Go or Stop)
## Further details
See the paper published in PLoS ONE for further experimental details, or get in touch at peter@petersmittenaar.com.

