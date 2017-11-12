# The Lone Clone

### A clone-themed game for the [Github Game-Off 2012](https://github.com/github/game-off-2012)

Make your way through 20 puzzlicious levels using only your power of cloning.

**Play it [here](http://codingcats.com/projects/the_lone_clone/index.html)!** It's played best on Chrome, but is slow/mute on Firefox. Also, if you're not hearing the music or if anything looks missing, try refreshing a few times (sorry!). Also, if you clone yourself a bunch of times in a small space and things get too cramped, it may freeze (sorry again!). If that happens, close the tab/window and try again.

**Note for judges:** I'll keep updating this game at the above url, so in fairness, here is the original version of the game as submitted midnight for GGO: [Original](http://codingcats.com/projects/the_lone_clone/index.html)

![Splash page](http://i.imgur.com/1ahvg.png)

![Gameplay](http://i.imgur.com/eDknv.png)

## Credits

#### Music
Pietnastka (Piotr Kurek) - [Website](http://www.piotrkurek.com/) - [FreeMusicArchive.org] (http://freemusicarchive.org/music/Pietnastka/)

#### Textures

[Bart](http://opengameart.org/users/bart) from [OpenGameArt.org](http://opengameart.org) - [Texture Pack](http://opengameart.org/content/19-high-res-stone-and-concrete-texture-photos)

#### Programming Tools
[box2dweb](http://code.google.com/p/box2dweb/) for physics engine

[requirejs](http://requirejs.org/) for code organization

[jQuery](http://jquery.com/) for convenient DOM manipulation

[jPlayer](http://www.jplayer.org/) for playing music

[Inkscape](http://inkscape.org/) as a handy level editor

[Guard](https://github.com/guard/guard) as an automated build tool

[coffeescript](http://coffeescript.org/) for programmer happiness

[Haml](http://haml.info/) for programmer happiness

[Sass](http://sass-lang.com/) for programmer happiness

[Rack](http://rack.github.com/) as a minimalist webserver

## How to build Locally

You'll need Ruby to use Guard, and node if you want to minify/uglify the javascript.

```
git clone git@github.com:jamesgary/The-Lone-Clone.git
cd The-Lone-Clone
bundle install
```

I like to have 2 tiny console windows up, one for Guard and the other for rack. So in one console:

```
bundle exec guard
```

and in another

```
rackup
```

Now go to [localhost:9292/public/dev/index.html](http://localhost:9292/public/dev/index.html) to see the game!

To minify and build for production, run the following:

```
./script/build
```

This will use `r.js` to concatenate and uglify your javascript files. You can then open [localhost:9292/public/prod/index.html](http://localhost:9292/public/prod/index.html) to make sure it all still works.
