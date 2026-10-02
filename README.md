# Amber

Tracking Amber Electric usage — https://amber.jamesst.one

Inspired by [Git scraping: track changes over time by scraping to a Git
repository](https://simonwillison.net/2020/Oct/9/git-scraping/): `events.json`
holds a single day of half-hourly usage, and every revision of it in git
history is replayed into `events.db` by
[`git-history`](https://github.com/simonw/git-history).

This is an archive. The Amber Electric account closed in 2022 and the
committed history stops in June that year, so there is nothing left to scrape;
`events.db` is rebuilt and published from the history that is here.

```bash
nix develop            # git-history, git, sqlite-utils
./run.sh build         # events.json history -> events.db
./run.sh commit-db     # force-push events.db to the `db` branch
```

`events.db` is not committed to `main`; the built database lives on the orphan
[`db`](../../src/branch/db) branch, and the build also installs it to
`/var/lib/datasette-sites/amber/events.db` on hermanii, where Datasette serves
it.
