# Snowflake-Visualisation
A Cellular Automata that visualises the growth of snowflakes and ice crystals.

This was written as part of my CS course, it is meant as an educational and recreational tool for learning about the formation of snowflakes and the different types. It is written in Processing (Java).\
By clicking on any of the hex cells, you can toggle the state of that cell to create different starting
configurations:
- white = not ice
- blue = ice 

In order for a snowflake to be able to grow, at least one cell on the grid must be ice to start.\
The cellular automata uses 3 rules to create new ice cells which in a normal run have different 
probabilities of being selected in order to create more realistic snowflakes.
- The Run button will run the simulation for 25 steps automatically to create a random snowflake.
- The Step button can be used to run a single step at a time and manually grow the snowflake.
- The Reset button will return the screen to the starting configuration.
- The Grow, Facet and Branch buttons each carry out that particular rule once so that you can test out different rules and permutations of rules.

The Drop-Down list contains 3 common classifications of snowflakes:
- plate: perfect hexagonal crystal, often grown very slowly at temperatures of 0 to -3.5 degrees.
- needle: long column shaped snowflakes, common at temperatures of -6 degrees.
- stellar dendrite: most recognisable snowflake with 6 branches and some additional side branches. These can come in many different forms and are common at temperatures of around -15 degrees.

Selecting any of these options will grow a basic snowflake of this classification on the screen. The drop-down list can be scrolled through since only 2 of the options will be shown at one time.\
Additionally, pressing the 's' key will save an image of the currently displayed snowflake to a file
called 'Snowflake.jpg' in the current folder.

I have also included the report about the code which details my design choices and implementation methods as well as an evaluation of the effectiveness.
