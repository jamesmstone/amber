# Amber

Tracking Amber Electric usage — https://amber.jamesst.one

Inspired by [Git scraping: track changes over time by scraping to a Git
repository](https://simonwillison.net/2020/Oct/9/git-scraping/): `events.json`
holds a single day of half-hourly usage, and every revision of it in git
history is replayed into `events.db` by
[`git-history`](https://github.com/simonw/git-history).

The scrape is dormant — the Amber account behind `AMBER_API_KEY` is closed, and
the committed history stops in June 2022. `events.db` is still rebuilt and
published from that history.

```bash
nix develop            # git-history, git, sqlite-utils
./run.sh fetch         # needs AMBER_SITE_ID and AMBER_API_KEY
./run.sh build         # events.json history -> events.db
./run.sh commit-db     # force-push events.db to the `db` branch
```

`events.db` is not committed to `main`; the built database lives on the orphan
[`db`](../../src/branch/db) branch, and the scrape also installs it to
`/var/lib/datasette-sites/amber/events.db` on hermanii, where Datasette serves
it.
