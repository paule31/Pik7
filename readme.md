Pik7
====

HTML5 presentation framework.

Features
--------

* 100% HTML5, CSS and JavaScript (jQuery)
* Programmable slides, easy to embed content from the web
* Great performance in modern browsers even with hundreds of slides
* Works in every modern browser
* As fancy or a simple as you want it to be
* Multiple synchronized presentation views and a presenter mode

Drawbacks
---------

* Requires a modern browser and a web server to run from (a simple server is included, but requires Node.js to work)
* Shares all drawbacks common to HTML slides (no GUI to create presentations, no PDF export, images hard to use)

How to use
----------

* `git clone git://github.com/SirPepe/Pik7.git && cd Pik7 && npm install && grunt`
* If you want to use the included web server: `node server.js`
* Copy the html file in `/presentations/Template` to `/presentations/yourslidestitle`. Edit/add slides (`<div class="pikSlide">`).
* Open the presentation framework (`index.html`) in a recent version of your favorite browser
* Use the "browse" link or the menu on the lower right to load your presentation
* For multiple presentation views simply open more instances of `index.html` in new browser windows
* Use the menu on the lower right to open the presenter view or point your browser to presenter.html
* Navigate slides using the arrow keys or tap near the edges of the screen. Hide the presentation using the F5 or ESC key
* See the slides about PIK7 (`/presentations/Pik7`) for more details.

To do
-----

* Do more testing
* Add more themes