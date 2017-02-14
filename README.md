# siteswap-diagram

Here's a little program that can generate arbitrarily large state transition diagrams...

State transition diagrams are a pretty neat way of coming up with new siteswaps. Each column is a 'state' and you 'transition' from a state by picking a number in that column, and following the arrow to the end.. Any loop you create doing this will be a valid siteswap.

Here's some demos. The colour was added afterwards, showing some possible loops (i.e. siteswaps) that can be found.

<div style="text-align:center"><img src ="https://github.com/oisincar/siteswap-diagram/blob/master/img/patterns3b.jpg" /></div>
<div style="text-align:center"> 531 (blue) and 51 (red) for 3 balls </div>

<div style="text-align:center"><img src ="https://github.com/oisincar/siteswap-diagram/blob/master/img/patterns4b.jpg" /></div>
<div style="text-align:center"> 7531 (blue), (5)561(3) (red), and 7777000 (green). </div>

## Compiling/ running.
You need to have ghc installed, and then run:

`ghc -o gen generator.hs `

to compile it, and

`./gen (#balls) (#max_throw_height)`

E.g. `./gen 3 5` to generate a diagram for 3 balls up to throw height 5.

It might be quite slow for larger throw heights. As right now generating the states is O(n!).
