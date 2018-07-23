Kerkerkruip Dungeon Generation by Victor Gijsbers begins here.

Use authorial modesty.



Book - The dungeon generation seed

[ We use an xorshift generator to produce all random numbers during the dungeon generation process. The dungeon seed is the initial xorshift seed in hexadecimal, 8 digits long. It might be possible to use seeds across minor updates, but we do not recommend it. ]

The dungeon generation seed is a number variable.

After showing the title screen (this is the seed the xorshift generator rule):
	[ Seed the xorshift generator ]
	if the dungeon generation seed is 0:
		seed the xorshift generator randomly;
		now the dungeon generation seed is the xorshift seed;
	otherwise:
		now the xorshift seed is the dungeon generation seed;

The show the banner with dungeon generation seed rule is listed instead of the display banner rule in the startup rules.
A startup rule (this is the show the banner with dungeon generation seed rule):
	say "[banner text]Dungeon seed: [dungeon generation seed in hexadecimal][line break]";
	now the xorshift seed is 0;

To say (value - a number) in hexadecimal:
	(- say_hex( {value}, 8 ); -).

Include (-
[ say_hex value digits i temp;
	for ( i = ( digits - 1 ) * 4 : i >= 0 : i = i - 4 )
	{
		@ushiftr value i temp;
		temp = temp & $0F;
		if ( temp > 9 )
		{
			print (char) ( temp + 55 );
		}
		else
		{
			print temp;
		}
	}
];
-).


Seed-showing is an action out of world. Understand "seed" as seed-showing.

Carry out seed-showing:
	say "The current dungeon seed is: [dungeon generation seed in hexadecimal]. The difficulty is: [difficulty]."



Book - Creating the Dungeon

A first when play begins rule (this is the create the dungeon rule):
	follow the dungeon generation rules.
	
The dungeon generation rules are a rulebook.

Map approved is a truth state that varies. Map approved is false.

A dungeon generation rule (this is the generate the map rule):
	now map approved is false;
	while map approved is false:
		print generation message "Generating map...";
		follow the resetting the map rules;
		follow the creating the map rules;
		if generation info is true, say "[paragraph break]";
		approve the map;
		if map approved is false:
			print generation message "Map rejected. ";

A dungeon generation rule (this is the place rogues rule):
	print generation message "Placing rogues...";
	place monsters;
	if generation info is true, say "[paragraph break]";

A dungeon generation rule (this is the place treasures rule):
	print generation message "Placing treasures...";
	stock the dungeon;

A dungeon generation rule (this is the more interesting stuff rule):
	print generation message "Making the dungeon more interesting...";
	make the dungeon interesting;

A dungeon generation rule (this is the finish generating rule):
	print generation message "Finishing the dungeon...";
	finish the dungeon;
	unless generation info is true:
		clear the screen.


Section - Generation message code (for use with Glimmr Canvas Animation by Erik Temple)

To print generation message (T - text):
	say T;
	start a 1 millisecond timer;
	wait for glk input;
	if the current glk event is timer-event:
		start a 0 millisecond timer;
	otherwise if the current glk event is glk-initiated:[handle window resizes, basically]
		let event-outcome be glk event handled in null-event context.

To start a/-- (T - a number) millisecond timer:
	(- if (glk_gestalt(gestalt_Timer, 0)) glk_request_timer_events({T});  -)

Section - Basic printing of generation messages (for use without Glimmr Canvas Animation by Erik Temple)

To print generation message (T - text):
	say T.


Section - Rarity and multiple die rolls

[Objects have a rarity. The probability of an object being put on the list for possible placement is 1/(2^rarity), i.e., 100% for rarity 0, 50% for rarity 1, 25% for rarity 2, and so on.]

An object has a number called the rarity. The rarity of an object is usually 0.

Definition: an object (called item) is rare if rarity of item is greater than 0.

To decide if (stuff - an object) is too rare:
	decide on whether or not any of (rarity of stuff) chances of 1 in 2 succeed.

To decide which number is the smallest of (roll count - a number) random numbers from (min - a number) to (max - a number):
	Let smallest be max;
	repeat with i running from 1 to roll count:
		Let die roll be a random number between min and max;
		if die roll < smallest:
			now smallest is die roll;
	decide on smallest.

To decide which number is the smallest of (roll count - a number) random numbers between (min - a number) and (max - a number):
	decide on the smallest of roll count random numbers from min to max.

To decide whether any of (roll count - a number) chances of (threshold - a number) in (die - a number) succeed:
	Let n be the smallest of roll count random numbers between 1 and die;
	decide on whether or not n is at most threshold.

To decide whether (roll count - a number) chances of (threshold - a number) in (die - a number) succeed:
	unless any of roll count chances of (die - threshold) in die succeed, yes;
	no.
	
To decide which number is the sum of (roll count - a number) random numbers from (min - a number) to (max - a number):
	Let sum be 0;
	repeat with i running from 1 to roll count:
		increase sum by a random number between min and max;
	decide on sum;

To decide which number is the sum of (roll count - a number) random numbers between (min - a number) and (max - a number):
	Decide on the sum of roll count random numbers from min to max.

Section - Basic and advanced modes

An object can be basic or advanced. An object is usually basic.

Basic game mode is a truth state variable.

A first dungeon generation rule (this is the decide basic mode rule):
	if the difficulty is 0 and advanced content is disabled and the dungeon generation seed is 0:
		now basic game mode is true.



Book - Creating the Map

Part - Preliminaries  

Section - Directions

A direction can be cardinal. A direction is usually not cardinal. North is cardinal. South is cardinal. East is cardinal. West is cardinal. Up is cardinal. Down is cardinal.

Section - Coordinates

A room has a number called the x-coordinate. [north]
A room has a number called the y-coordinate. [east]
A room has a number called the z-coordinate. [up]

Section - Placed and unplaced

A room can be placed. A room is usually not placed.

Section - Global variables

Considered room is a room that varies. [The room to be placed.]
Original room is a room that varies. [The room from which it is placed.]

Considered-x is a number that varies. [Coordinates of the new location.]
Considered-y is a number that varies.
Considered-z is a number that varies.

Current room score is a number that varies. [Used to check likelihood of placement.]

Additional considered room is a room that varies. [For use with additional placement rules. Please do not take them a step further.]
Additional original room is a room that varies.



Part - Main Routines

Chapter - Resetting and Creating the Map

Section - Resetting the map

The resetting the map rules are a rulebook.

First resetting the map rule (this is the destroy all connections rule):
	repeat with place running through rooms:
		now place is not placed;
		repeat with way running through cardinal directions:
			change the way exit of place to nothing;
		now the x-coordinate of place is 100;
		now the y-coordinate of place is 100;
		now the z-coordinate of place is 100.

Resetting the map rule (this is the we start with entrance Hall rule):
	now the x-coordinate of Entrance Hall is 0;
	now the y-coordinate of Entrance Hall is 0;
	now the z-coordinate of Entrance Hall is 0;
	now Entrance Hall is placed.

Section - Creating the map

The creating the map rules are a rulebook.

Creating the map rule (this is the locate and connect all rooms rule):
	while less than twelve rooms are placed or less than eight habitable rooms are placed:
		let place be a random placed room;
		let way be a random cardinal direction;
		if way is up or way is down:
			now way is a random cardinal direction; [This makes the map more horizontal.]
		let x be the x way of place;
		let y be the y way of place;
		let z be the z way of place;
		if the space at x by y by z is free:
			let chosen room be a suitable room from place at x by y by z;
			if chosen room is Entrance Hall:
				if generation info is true, say "* No suitable rooms found. Trying again...";
			otherwise:
				place chosen room from place at x by y by z;

Section - Making Connections

To connect (destination - a room) to (origin - a room):
	if origin is not placed and destination is placed:
		connect origin to destination;
	if origin is not placed:
		say "*** Run-Time Problem: Tried to connect [destination] to [origin], when [origin] is not placed.";
	Let way be the direction from origin to destination;
	change the way exit of origin to destination;
	Let reverse be the opposite of way;
	change the reverse exit of destination to origin;
	[We might run into problems if we connect a destination to a secret room -
	even though the destination is unreachable, it is not marked as secret.
	We should take care not to do that during map generation, although
	it is perfectly fine when digging.]
	mark destination as openly placed;

Section - Adding tunnels

Last creating the map rule (this is the potentially add a tunnel rule):
	if a random chance of 1 in 3 succeeds:
		create a tunnel;
	if a random chance of 1 in 6 succeeds:
		create a tunnel.
		
To create a tunnel:
	let P be a random normally placed connectable room;
	let Q be P;
	while Q is P:
		now Q is a random normally placed connectable room;
	if generation info is true, say "* Building a tunnel between [P] and [Q].[line break][run paragraph on]";			
	let R be false;
	while R is false:
		if absolute distance between P and Q is 1:
			if generation info is true, say "* Adding connection between [P] and [Q]. Destination reached.[line break][run paragraph on]";
			connect P to Q;
			now R is true;
		otherwise:
			if the number of rooms surrounding x-coordinate of P by y-coordinate of P by z-coordinate of P is the number of cardinal directions:
				if generation info is true, say "* Giving up on tunnel building.[line break][run paragraph on]";	
				now R is true;
			otherwise:
				let building block be a random not placed tunnel;
				if a random chance of 1 in 5 succeeds: [go in a random direction]
					place building block next to P;
					now P is building block;
				otherwise:
					let way be a single general direction from P to Q;
					let x be the x way of P;
					let y be the y way of P;
					let z be the z way of P;
					if the space at x by y by z is free:
						place building block from P at x by y by z;
						now P is building block;
					otherwise:
						let T be the room at x by y by z;
						if T is placeable and T is connectable:
							if generation info is true, say "* Adding connection between [P] and [T].[line break][run paragraph on]";
							connect P to T;
							now P is T;
						otherwise:
							if generation info is true, say "* Giving up on tunnel building.[line break][run paragraph on]";	
							now R is true;
		if R is false and number of not placed tunnels is less than 26:
			if generation info is true, say "* Giving up on tunnel building.[line break][run paragraph on]";
			now R is true.


		
Section - Additional connections and collapsable passages

Collapse relates rooms to each other. The verb to collapse (he collapses, they collapse, he collapsed, it is collapsed, he is collapsing) implies the collapse relation.
			
Last creating the map (this is the possibly adding some further connections rule):
	repeat with place running through normally placed connectable rooms:
		repeat with further place running through normally placed connectable rooms:
			let way be the direction from place to further place;
			if way is not northwest:
				if further place is not the room way of place:
					if a random chance of 1 in 4 succeeds or place is connection-inviting or further place is connection-inviting: [gives a roughly 1 in 2 chance of connections being made]
						if generation info is true, say "* Adding connection between [place] and [further place].[line break][run paragraph on]";
						connect place to further place;
						if a random chance of 1 in 4 succeeds:
							now place collapses further place.


Resetting the map rule (this is the reset collapse rule):
	repeat with place running through rooms:
		while at least one room collapses place:
			let place2 be a random room that collapses place;
			now place2 does not collapse place.

						
Chapter - Approving the map

Distance-1 and distance-2 are numbers that vary.
	
To approve the map:
	follow the map approval rules;
	unless rule failed, now map approved is true.
								
The map approval rules are a rulebook.

To decide which number is the distance of (place - a room):
	decide on the number of moves from place to Entrance Hall.

[we want to branch out quickly so the player has choices.]
A map approval rule (this is the beginning shouldn't be too narrow rule):
	now distance-1 is 0;
	now distance-2 is 0;
	repeat with place running through placed rooms:
		if distance of place is 1, increase distance-1 by 1;
		if distance of place is 2, increase distance-2 by 1;
	if distance-1 plus distance-2 is not greater than 4:
		if generation info is true, say "There are only [distance-1] rooms next to Entrance Hall and only [distance-2] rooms two moves from Entrance Hall. ";
		rule fails;


Section - Additional placement rules
	
The additional placement rules are a rulebook.	
	
									
			
Chapter - Choosing the right room

Section - Building a list of suitable rooms

Table of Suitable Rooms
Candidate	Room Score
a room	a number
with 30 blank rows

To fill the Table of Suitable Rooms:
	blank out the whole of the Table of Suitable Rooms;
	repeat with place running through placeable not placed rooms:
[		say place, " ";]
		now considered room is place;
		follow the placement possible rules;
		if rule succeeded:
			[say "! ";]
			choose a blank row in the Table of Suitable Rooms;
			now the Candidate entry is place;
			now the Room Score entry is 0.

The placement possible rules are a rulebook.

Placement possible rule (this is the adjust rooms for rarity rule):
	if considered room is too rare:
		rule fails.

Placement possible rule (this is the do not place advanced rooms in novice mode rule):
	if considered room is advanced and basic game mode is true:
		rule fails.

Last placement possible rule:
	rule succeeds.

Section - Scoring the suitable rooms

To score the suitable rooms:
	repeat through the Table of Suitable Rooms:
		now considered room is the Candidate entry;
		now current room score is 0;
		follow the placement scoring rules;
		now the Room Score entry is current room score.

The placement scoring rules are a rulebook.


Section - Choosing a suitable room

To decide which room is a suitable room from (place - a room) at (x - a number) by (y - a number) by (z - a number):
	now original room is place;
	now considered-x is x;
	now considered-y is y;
	now considered-z is z;
	fill the Table of Suitable Rooms;
	score the suitable rooms;
	sort Table of Suitable rooms in random order;
	sort Table of Suitable rooms in reverse Room Score order;
[	repeat through Table of Suitable Rooms:
		say "[Candidate entry] at [Room score entry] points.";]
	let the worst choice be the number of filled rows in Table of Suitable Rooms;
	if the worst choice is 0:
		decide on Entrance Hall;
	otherwise:
		let the choice be the worst choice;
		repeat with improvement running from 1 to 3:
			let the better choice be a random number between 1 and the worst choice;
			if the better choice is less than the choice, now the choice is the better choice;
		choose row choice in the Table of Suitable rooms;
		decide on Candidate entry.

Part - Additional Routines

Chapter - Placing rooms

Section - Placing a room at a specific location
			
To place (new place - a room) from (original place - a room) at (x - a number) by (y - a number) by (z - a number):			
	unless new place is Entrance Hall: [which would mean failure]
		now x-coordinate of new place is x;
		now y-coordinate of new place is y;
		now z-coordinate of new place is z;
		connect original place to new place;
		if generation info is true, say "* [best route from original place to new place] of [original place] ([x-coordinate of original place], [y-coordinate of original place], [z-coordinate of original place]) is [new place] ([x], [y], [z]).[line break][run paragraph on]";
		now additional considered room is new place;
		now additional original room is original place;
		follow the additional placement rules.

Section - Placing a room next to another room			

To place (a - a room) next to (b - a room):
	unless the number of rooms surrounding x-coordinate of b by y-coordinate of b by z-coordinate of b is the number of cardinal directions:
		while a is not placed:			
			let way be a random cardinal direction;
			let x be the x way of b;
			let y be the y way of b;
			let z be the z way of b;
			if the space at x by y by z is free:
				now x-coordinate of a is x;
				now y-coordinate of a is y;
				now z-coordinate of a is z;
				if b is secretly placed:
					say "*** Run-Time Problem (warning): Placing [a] next to [b], which is secretly placed.";
				connect a to b;
				if generation info is true, say "* Placed [a] [best route from b to a] of [b].[line break][run paragraph on]".
			
Chapter - Other routines

Section - Absolute distance

[This routine stolen from Fixed Point Maths version 5 by Michael Callaghan.] [Made obsolete by 6L02]

To decide which number is the integer absolute value of (N - a number):
	if N is less than 0:
		let N be 0 minus N;
	decide on N.

To decide which number is the absolute distance between (a - a room) and (b - a room):
	let count be 0;
	let temp be x-coordinate of a minus x-coordinate of b;
	increase count by the integer absolute value of temp;
	let temp be y-coordinate of a minus y-coordinate of b;
	increase count by the integer absolute value of temp;
	let temp be z-coordinate of a minus z-coordinate of b;
	increase count by the integer absolute value of temp;
	decide on count.
	
Section - Direction between rooms	
	
To decide which direction is the direction from (a - a room) to (b - a room):
	if absolute distance between a and b is not 1:
		decide on northwest; [Capture this as a failure!]
	otherwise:
		if x-coordinate of a minus x-coordinate of b is -1:
			decide on north;
		if x-coordinate of a minus x-coordinate of b is 1:
			decide on south;
		if y-coordinate of a minus y-coordinate of b is -1:
			decide on east;
		if y-coordinate of a minus y-coordinate of b is 1:
			decide on west;
		if z-coordinate of a minus z-coordinate of b is -1:
			decide on up;
		if z-coordinate of a minus z-coordinate of b is 1:
			decide on down.

[The randoms below are to make the choice of direction fair.]

To decide which direction is a single general direction from (a - a room) to (b - a room):
	if a random chance of 1 in 3 succeeds:
		if x-coordinate of a is greater than x-coordinate of b:
			decide on south;
		if x-coordinate of a is less than x-coordinate of b:
			decide on north;
	if a random chance of 1 in 2 succeeds:
		if y-coordinate of a is greater than y-coordinate of b:
			decide on west;
		if y-coordinate of a is less than y-coordinate of b:
			decide on east;		
	if z-coordinate of a is greater than z-coordinate of b:
		decide on down;
	if z-coordinate of a is less than z-coordinate of b:
		decide on up;
	if a random chance of 1 in 2 succeeds:
		if x-coordinate of a is greater than x-coordinate of b:
			decide on south;
		if x-coordinate of a is less than x-coordinate of b:
			decide on north;
	if y-coordinate of a is greater than y-coordinate of b:
		decide on west;
	if y-coordinate of a is less than y-coordinate of b:
		decide on east;
	if x-coordinate of a is greater than x-coordinate of b:
		decide on south;
	if x-coordinate of a is less than x-coordinate of b:
		decide on north.



Section - Number of surrounding rooms
			
To decide which number is the number of rooms surrounding (a - a number) by (b - a number) by (c - a number):
	let count-1 be 0;
	repeat with place running through placed rooms:
		let count-2 be 0;
		let temp be x-coordinate of place minus a;
		increase count-2 by the integer absolute value of temp;
		let temp be y-coordinate of place minus b;
		increase count-2 by the integer absolute value of temp;
		let temp be z-coordinate of place minus c;
		increase count-2 by the integer absolute value of temp;
		if count-2 is 1:
			increase count-1 by 1;
	decide on count-1.

Section - Whether a location is free

To decide whether the space at (a - a number) by (b - a number) by (c - a number) is free:
	repeat with checked place running through placed rooms:
		if x-coordinate of checked place is a:
			 if y-coordinate of checked place is b:
				if z-coordinate of checked place is c:
					decide no;
	decide yes.

Section - What is the room at a location

To decide what room is the room at (a - a number) by (b - a number) by (c - a number):
	repeat with checked place running through placed rooms:
		if x-coordinate of checked place is a:
			 if y-coordinate of checked place is b:
				if z-coordinate of checked place is c:
					decide on checked place.


Section - The x, y and z way

To decide what number is the x (way - a direction) of (place - a room):
	if way is north:
		decide on x-coordinate of place + 1;
	if way is south:
		decide on x-coordinate of place - 1;
	otherwise:
		decide on x-coordinate of place.

To decide what number is the y (way - a direction) of (place - a room):
	if way is east:
		decide on y-coordinate of place + 1;
	if way is west:
		decide on y-coordinate of place - 1;
	otherwise:
		decide on y-coordinate of place.
		
To decide what number is the z (way - a direction) of (place - a room):
	if way is up:
		decide on z-coordinate of place + 1;
	if way is down:
		decide on z-coordinate of place - 1;
	otherwise:
		decide on z-coordinate of place.								











Book - Monster Placement

Section - Monsters

A monster is a kind of person. A person has a number called the level. The level of a person is usually 0.
A person has a number called the group level. The group level of a person is usually 0. [Only for monsters who are part of a group.]

Section - Global variables

[We also use some from the dungeon generation routines above]

Global monster level is a number that varies. [The level monster we are looking for.]
Considered monster is a monster that varies. [The monster we are considering.]
Current monster score is a number that varies. [Tracks how appropriate the current monster is.]



Chapter - Main routines

Section - The Table of monsters

Table of Monster Rooms
Locale	Distance	Level
a room	a number	a number
with 20 blank rows


Section - Calling the routines

The final monster placement rules are a rulebook.

To place monsters:
	clear all monsters;
	set up Table of Monster Rooms;
	fill the Table of Monster Rooms;
	put monsters in the rooms;
	follow the final monster placement rules.
	
	
Section - Clearing all monsters
	
To clear all monsters:
	repeat with guy running through monsters:
		remove guy from play.	


Section - Setting up the table	
	
To set up Table of Monster Rooms:
	blank out the whole of the Table of Monster Rooms;
	repeat with place running through placed habitable rooms:
		choose a blank row in the Table of Monster Rooms;
		now Locale entry is place;
		now Distance entry is distance of place;
		now Level entry is 0.
	

Section - Filling the table	
	
To fill the Table of Monster Rooms:
	if distance-1 is 1:
		if 1 is a distance listed in the Table of Monster Rooms:
			choose a row with a distance of 1 in the Table of Monster Rooms;
			blank out the whole row;
	if distance-2 is 1 and at least eight habitable rooms are placed:
		if 1 is a distance listed in the Table of Monster Rooms:
			choose a row with a distance of 1 in the Table of Monster Rooms;
			blank out the whole row;
	sort Table of Monster Rooms in random order;
	sort Table of Monster Rooms in Distance order;
	while the number of filled rows in Table of Monster Rooms is greater than 7:
		let n be the number of filled rows in Table of Monster Rooms;
		let m be a random number between 2 and n - 1;
		choose row m from the Table of Monster Rooms;
		blank out the whole row;
		sort Table of Monster Rooms in Distance order;
	choose row 1 from the Table of Monster Rooms;
	now Level entry is 1;
	choose row 2 from the Table of Monster Rooms;
	now Level entry is 2;
	choose row 3 from the Table of Monster Rooms;
	now Level entry is 1;
	choose row 4 from the Table of Monster Rooms;
	now Level entry is 3;
	choose row 5 from the Table of Monster Rooms;
	now Level entry is 2;
	choose row 6 from the Table of Monster Rooms;
	now Level entry is 4;
	choose row 7 from the Table of Monster Rooms;
	now Level entry is 5.

[At this point, we have a table which says which rooms should contain what level of monster.]
	


Chapter - Choosing monsters in each room

Section - Table of Suitable Monsters

Table of Suitable Monsters
Applicant	Monster score
a monster	a number
with 30 blank rows

Section - Putting monsters in rooms

To put monsters in the rooms:
	repeat through the Table of Monster Rooms:
[		say locale entry;]
		now considered room is locale entry;
		now global monster level is level entry;
		fill the Table of Suitable Monsters;
		score the suitable monsters;
		let max be the number of filled rows in Table of Suitable Monsters;
[		say max;]
		if max is not 0:
			sort Table of Suitable monsters in random order;
			sort Table of Suitable monsters in reverse Monster Score order;
			let pos1 be the smallest of 3 random numbers between 1 and max;
[			say "(choosing row [pos1] out of [max])";]
			choose row pos1 in the Table of Suitable Monsters;
			if generation info is true, say "* Placing suitable monster choice [pos1], [applicant entry] (level [global monster level]) in [considered room].[line break][run paragraph on]";
			move applicant entry to considered room.

Section - Filling the Table of Suitable Monsters

To fill the Table of Suitable Monsters:
	blank out the whole of the Table of Suitable Monsters;
	repeat with guy running through off-stage monsters:
	[		say guy, " ";]
		now considered monster is guy;
		follow the monster placement possible rules;
		if rule succeeded:
			[say "! ";]
			choose a blank row in the Table of Suitable Monsters;
			now the Applicant entry is guy;
			now the Monster Score entry is 0.



The monster placement possible rules are a rulebook.

First monster placement possible rule (this is the only monsters of the right level rule):
	if the level of considered monster is not global monster level:
		rule fails.

Monster placement possible rule (this is the do not place advanced monsters in novice mode rule):
	if the considered monster is advanced and basic game mode is true:
		rule fails.
		
Monster placement possible rule (this is the do not use groupers rule):
	if considered monster is grouper:
		rule fails.		

Last monster placement possible rule:
	rule succeeds.
	
Section - Scoring the monsters

To score the suitable monsters:
	repeat through the Table of Suitable Monsters:
		now considered monster is the Applicant entry;
		now current monster score is 0;
		follow the monster placement scoring rules;
		now the Monster Score entry is current monster score.

The monster placement scoring rules are a rulebook.



Book - Treasures

To stock the dungeon:
	follow the treasure placement rules;
	if generation info is true, say "[paragraph break][paragraph break]".
	
The treasure placement rules are a rulebook.


Section - Treasure placement

Considered treasure is a thing that varies.

First treasure placement rule (this is the remove rare items rule):
	repeat with X running through rare not non-treasure things:
		if X is too rare:
			now X is non-treasure;
			if generation info is true:
				say "* Decided that [X] is too rare. ".
			
First treasure placement rule (this is the remove advanced items in basic mode rule):
	if basic game mode is true:
		repeat with X running through advanced things:
			now X is non-treasure;

To place between (min - a number) and (max - a number) treasures from (D - a description of objects):
	let stuff be a thing;
	Let n be the number of D;
	Let m be a random number from min to max;
	if m > n:
		now m is n;
	Repeat with i running from 1 to m:
		now stuff is a random D;
		now considered treasure is stuff;
		choose a room;
		move stuff to considered room;
		if generation info is true, say "* placed [stuff] in [considered room]".
		
A treasure placement rule (this is the stock minor treasure rule):
	print generation message "    Placing minor treasures...";
	place between 7 and 14 treasures from off-stage minor things.
			
A treasure placement rule (this is the stock major treasure rule):
	print generation message "    Placing major treasures...";
	place between 4 and 6 treasures from off-stage major things.

A treasure placement rule (this is the stock epic treasure rule):
	print generation message "    Placing epic treasures (well, you hope)...";
	place between 1 and 2 treasures from off-stage epic things.		

A treasure placement rule (this is the stock special treasure rule):
	print generation message "    Placing special treasures...";
	place between 0 and 1 treasures from off-stage special things.

Section - Choosing a room

[The item is in considered treasure, and we must generate a considered room.]
[We re-use the Table of Suitable Rooms]

To choose a room:
	fill the Table of Suitable Rooms for treasure;
	score the suitable rooms for treasure;
	sort Table of Suitable rooms in random order;
	sort Table of Suitable rooms in reverse Room Score order;
[	repeat through Table of Suitable Rooms:
		say "[Candidate entry]: [Room Score entry]";]
	let max be the number of filled rows in Table of Suitable Rooms;
	if max is 0:
		now considered room is Entrance Hall;
	otherwise:
		let pos1 be the smallest of 3 random numbers between 1 and max;
		choose row pos1 in the Table of Suitable rooms;
		now considered room is Candidate entry.

To fill the Table of Suitable Rooms for treasure:
	blank out the whole of the Table of Suitable Rooms;
	repeat with place running through treasurable placed rooms:
[		say place, " ";]
		now considered room is place;
		choose a blank row in the Table of Suitable Rooms;
		now the Candidate entry is place;
		now the Room Score entry is 0.

To score the suitable rooms for treasure:
	repeat through the Table of Suitable Rooms:
		now considered room is the Candidate entry;
		now current room score is 0;
		follow the treasure scoring rules;
		[say "[considered treasure]; [considered room]; [current room score]";]
		now the Room Score entry is current room score.

The treasure scoring rules are a rulebook.



Section - Additional routines

To place (i - a number) of (worth - a valuation) things in (coffer - an object):
	let n be a number;
	let item be a thing;
	if basic game mode is true:
		now n is the number of off-stage basic things valuing worth;
	otherwise:
		now n is the number of off-stage things valuing worth;
	let m be i;
	if m is greater than n, now m is n;
	while m is greater than 0:
		if basic game mode is true:
			now item is a random off-stage basic thing valuing worth;
		otherwise:
			now item is a random off-stage thing valuing worth;
		move item to coffer;
		if generation info is true, say "* Putting [item] in [coffer].";
		decrease m by 1.



Book - Making the dungeon interesting

The dungeon interest rules are a rulebook.

To make the dungeon interesting:
	follow the dungeon interest rules.

Book - Finishing the dungeon

The dungeon finish rules are a rulebook.

To finish the dungeon:
	follow the dungeon finish rules.


Kerkerkruip Dungeon Generation ends here.