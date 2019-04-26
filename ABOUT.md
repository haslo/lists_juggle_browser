### Many thanks to...

* Haslo for creating meta-wing for X-Wing version 1.0, this update to support 2.0 wouldn't be here without all his hard work and code. I really just updated it as minimally as possible.
* [FFG's fantastic X-Wing miniatures game](https://www.fantasyflightgames.com/en/products/x-wing),
of course
* [X-Wing Lists Fortress](http://listfortress.com/), antigrapist who built it and hosts Meta-wing 2.0, and all the folks,
who contributed data by adding their tournaments
* Guido Kessels and his [xwing-data repository](https://github.com/guidokessels/xwing-data2)
* The [X-Wing Miniatures Font](https://github.com/geordanr/xwing-miniatures-font) for symbols and icons
* Everybody behind the [XWS Spec](https://github.com/elistevens/xws-spec)

### Support

If you'd like to support and help pay for the hosting of ListFortress and Meta-Wing 2.0 please visit the [Scum & Villany podcast patreon](https://www.patreon.com/scumandvillainy) and consider becoming a patron. They keep the lights on.

### Implementation

The original X-Wing 1.0 [source is available on GitHub](https://github.com/haslo/lists_juggle_browser) with an MIT license, and the version 2.0 [source is available on GitHub](https://github.com/AlexRaubach/lists_juggle_browser) with an MIT license.
The application stack uses [PostgreSQL](https://www.postgresql.org/), [Ruby on Rails](http://rubyonrails.org/),
[jQuery](https://jquery.com/) and [Bootstrap](http://getbootstrap.com/). The server runs
[nginx](https://www.nginx.com/solutions/web-server/) in front of [puma](http://puma.io/) on
[Ubuntu](https://www.ubuntu.com/). The image export uses [ChunkyPNG](http://chunkypng.com/) with [OilyPNG](https://github.com/wvanbergen/oily_png).

Imports are automatic (based on xwing-data), and things like list archetypes the DB doesn't know yet are automagically
generated, which means they'll never get stale because no human interaction is involved. On the other hand, my database
has no clue what these things (ships, pilots, upgrades) represent and whether the combinations it gets are legal
or posible, they're just a name and a number without anything else attached.

### Algorithms

I'm ranking things based on one primary attribute: Ranking percentiles. For this, I calculate the percentile of each
squadron's result in each tournament, already when importing the List Fortress data. Like that, I can then do all
the heavy lifting in the database, which results in reasonable performance even for complex filters in queries.

Examples (slightly simplified): `3rd of 12 => 75th percentile`, `9th of 90 => 90th percentile` - and after the cut:
`2nd of 16 in cut of 80 => 87.5th percentile`.

The ranking then adds these percentiles for the chosen rankings (Swiss or cut or both), which results in a value I
call "Weighted Score". Two multipliers are used on this Weighted Score value, if used for the filter: `log(number of players in tournament)`
in order to reward heavy competition, and `log(number of squadrons who used this thing, total)` in order to bring things
to the top that are prevalent in the meta.

If you want more precise information, then you can always
[Use the Source](https://github.com/haslo/lists_juggle_browser/blob/master/app/models/rankers/weight_query_builder.rb).
Maybe I'll change the algorithm to something more founded in statistics some time, but for now, it appears to bring the
squads one would expect to the top.

### Editing Contents

You might have noticed edit buttons here and there. Feel free to fix any wrong or missing data, particularly list
archetype names.

The Wikia links should go to the corresponding upgrade / pilot page, and that will result in the correct images being
used for pilots and upgrades. The classes refer to [this list](https://geordanr.github.io/xwing-miniatures-font/)
(without prefixes).

### Author

The author of Meta-Wing for X-Wing version 1.0 is known as haslo on the FFG forums, BGG, GitHub, Twitter. Throw him a note in any of those places.

The author of the update to X-Xwing version 2.0 is known as mwhited on GitHub and the Vassal Slack, or @WhitedLightning on Twitter, hit me up in any of those places or
[create an issue on GitHub](https://github.com/AlexRaubach/lists_juggle_browser/issues) if you find bugs or have ideas for
improvements.
