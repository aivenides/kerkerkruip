Kerkerkruip Events by Victor Gijsbers begins here.

Use authorial modesty.

[Events are what Kerkerkruip uses to cleanly model complicated interactions. An event consists of a "to" phrase and a rulebook. Anything in the game that makes the event happen should call the "to" phrase with the appropriate information; anything in the game that reacts to events of this kind should add rules to the rulebook.

This allows us to have complicated interactions and yet (a) keep all code local, (b) avoid code duplication, and (c) avoid combinatorial explosion.

You may want to check out this blog post for more information: http://gamingphilosopher.blogspot.com/2011/10/inform-7-complex-interaction-events-and.html]


Chapter - Falling

Falling-guy is a person that varies.
Falling-place is a room that varies.
Falling-reason is a number that varies.
Falling-destination is a room that varies.

To have a falling event with (guy - a person) falling in (place - a room) for reason (reason - a number):
	now falling-guy is guy;
	now falling-place is place;
	now falling-reason is reason;
	follow the falling destination rules;
	follow the preempt falling rules;
	follow the falling rules.
	
The falling destination rules are a rulebook.
The preempt falling rules are a rulebook. [For late effects that happen when we start falling.]
The falling rules are a rulebook.

[Substantial rules in Systems/Falling.]

[Reasons:
0 - no reason
1 - hit in combat
2- jumped voluntarily]


Chapter - Fragmentation

Fragmentation-place is a room that varies.
Fragmentation-guy is a person that varies.
Fragmentation-item is a thing that varies.

To have a fragmentation event in (place - a room) with (item - a thing) by (guy - a person):
	now fragmentation-place is place;
	now fragmentation-guy is guy;
	now fragmentation-item is item;		
	follow the fragmentation rules.

The fragmentation rules are a rulebook.

[The item itself should start the description, e.g., The grenade explodes, dealing [run paragraph on]]

First fragmentation rule (this is the remove item from play rule):
	remove fragmentation-item from play.

A fragmentation rule (this is the basic fragmentation damage rule):
	let n be the number of alive persons in fragmentation-place;
	let original n be n;
	let kill-list be a list of persons;
	repeat with guy running through all alive persons in fragmentation-place:
		let m be a random number between 2 and 5;
		deal m points of physical damage;
		if fragmentation-place is the location:
			say "[if n is 1 and original n is not 1] and[end if] [run paragraph on]";
			have fragmentation-item inflict damage on guy;
			say " [damage consequences][if n is not 1];[otherwise].[line break][end if][run paragraph on]";
		otherwise:
			have fragmentation-item inflict damage on guy, silently;	
		decrease n by 1;
		if n is 0:
			if fragmentation-place is the location:
				say ""; [For an extra newline. Don't ask.]
		if health of guy is less than 1:
			add guy to kill-list;
		now guy is not asleep;
	repeat with guy running through kill-list:
		have an event of fragmentation-guy killing the guy;
	if health of the player is less than 1:
		if fragmentation-guy is the player:
			end the story saying "You have blown yourself to pieces";
		otherwise:
			end the story saying "You have been blown to pieces".

A fragmentation rule (this is the glass items can shatter through fragmentation rule):
	repeat with item running through glass things enclosed by fragmentation-place:
		if item is not enclosed by a closed container:
			if a random chance of 1 in 20 succeeds:
				have a shatter event with item.


Chapter - Killing

[When X kills Y]

Killer-guy is a person that varies.
Killed-guy is a person that varies.

To have an event of (guy - a person) killing (guy2 - a person):
	now killer-guy is guy;
	now killed-guy is guy2;
	follow the killing rules.

The killing rules are a rulebook.


Chapter - Shattering

[Some items may shatter.]

Shatter-item is a thing that varies.

To have a shatter event with (item - a thing):
	now shatter-item is item;
	follow the shatter rules.

The shatter rules are a rulebook.

Shatter rule (this is the people shattering rule):
	if shatter-item is a person:
		now health of shatter-item is -100;
		if shatter-item is the player:
			end the story saying "Your body shattered to pieces!";
		otherwise:
			say "[The shatter-item] [bold type]shatter[unless shatter-item is plural-named]s[end if][roman type] to pieces!";
		rule succeeds.

Shatter rule (this is the things shattering rule):
	remove shatter-item from play;
	say "[The shatter-item] [bold type]shatter[unless shatter-item is plural-named]s[end if][roman type]."






Kerkerkruip Events ends here.