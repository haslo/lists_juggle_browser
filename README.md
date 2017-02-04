# Lists Juggle Browser

An application that takes the wealth of data from Lists Juggler, and tries to
distill it down into a number of reports that answer questions the community might
have.

Here's the source of the Lists Juggler frontend and data:
https://github.com/lhayhurst/xwlists

Huge props to the guys who built that!

I'm also using images from the X-Wing Fandom Wikia, linking to the source from
wherever I use an image.

And finally, thanks to everybody who helps with the X-Wing Miniatures Font:
https://github.com/geordanr/xwing-miniatures-font

## Application Stack

The application is written in Ruby on Rails and uses PostgreSQL as its database.

Preferably, use something like RVM to handle your Rubies and Gemsets. Then checkout
the repository, make sure you're using Ruby 2.4, and...

```bash
bundle
rake db:create db:migrate
```

...and done. It might not work as easily on Windows, because Windows.

Importing all the data (takes a while):

```bash
rake sync:all
rake sync:rebuild_wikia_images
```

You'll need to fix some Wikia links afterwards (from detail pages), but
most should be correct.
