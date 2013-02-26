Pik7
====

HTML5 presentation framework.

![Screenshot](https://github.com/SirPepe/Pik7/raw/master/screenshot.png)

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

1. Download from [https://github.com/SirPepe/Pik7/tags](https://github.com/SirPepe/Pik7/tags) or `git clone git://github.com/SirPepe/Pik7.git`
2. Install dependencies: `npm install` and `sudo npm install -g bower && bower install`
3. Build: `grunt`
4. If you want to use the included web server: `node server.js`
5. Copy the html file in `/presentations/Template` to `/presentations/yourslidestitle`. Edit/add slides (`<div class="pikSlide">`).
6. Open the presentation framework (`index.html`) in a recent version of your favorite browser
7. Use the "browse" link or the menu on the lower right to load your presentation
8. Use the menu on the lower right to open the presenter view or point your browser to `presenter.html`
9. Navigate slides using the arrow keys or tap near the edges of the screen. Hide the presentation using the F5 or ESC key
10. See the slides about PIK7 (`/presentations/Pik7`) for more details.

To do
-----

* Do more testing
* Add more themes
* Fix broken doc generation