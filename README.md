# Lists Juggle Browser

An application that takes the wealth of data from Lists Juggler, and tries to
distill it down into a number of reports that answer questions the community might
have.

Here's the source of the Lists Juggler frontend and data:
https://github.com/lhayhurst/xwlists

Huge props to the guys who built that!

I'm also using images from the X-Wing Fandom Wikia, linking to the source from
wherever I use an image.

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
rake sync:lists_juggler
```

## Current Status

Currently, the application can import data from Lists Juggler through their HTML lists
and CSV exports, and wrangle it into new tables to hold everything. There's also some
pre-computation of values for statistics.

Next up will be a little UI for the whole thing, and then lots of heavy lifting with
the data.
