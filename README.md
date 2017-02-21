# Lists Juggle Browser

An application that takes the wealth of data from Lists Juggler, and tries to
distill it down into a number of reports that answer questions the community might
have.

## Application Stack

The application is written in Ruby on Rails and uses PostgreSQL as its database.

Preferably, use something like RVM to handle your Rubies and Gemsets. Then checkout
the repository (including the submodule), make sure you're using Ruby 2.4 and have
Postgres installed, and...

```bash
cp config/database.yml.example config/database.yml
bundle
rake db:create db:migrate
```

...and done. It might not work as easily on Windows, because Windows.

Importing all the data (takes a while):

```bash
rake sync:xwing_data
rake sync:tournaments
rake sync:rebuild_rankings
```

For updates later (updates everything):

```bash
rake sync:tournaments[<min_id>,<min_date>]
rake sync:rebuild_rankings[<min_id>,<min_date>]
```
Both parameters are optional for both rake tasks, just skip the brackets if you
don't want to provide them.
