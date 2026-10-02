#!/usr/bin/env bash
set -euo pipefail

db="events.db"
dbBranch="db"

fetch() {
  local d
  d=$(date --date=yesterday +'%Y-%m-%d')
  curl -fsS \
    "https://api.amber.com.au/v1/sites/${AMBER_SITE_ID}/usage?startDate=${d}&endDate=${d}&resolution=30" \
    -H "Accept: application/json" \
    -H "Authorization: Bearer ${AMBER_API_KEY}" \
    -o events.json
  cat events.json
}

# Replays every revision of events.json, so it needs the full git history.
build() {
  rm -f "$db"
  git-history file "$db" events.json --convert '
import json
data = json.loads(content)
# A failed scrape left {"message": null} in place of the usual array.
return data if isinstance(data, list) else []
'
}

commitDB() {
  local tempDB
  tempDB="$(mktemp)"
  git config user.name "Automated"
  git config user.email "actions@jamesst.one"
  git branch -D "$dbBranch" || true
  git checkout --orphan "$dbBranch"
  mv "$db" "$tempDB"
  git rm -rqf .
  mv "$tempDB" "$db"
  git add -f "$db"
  git commit -m "push db"
  git push origin "HEAD:$dbBranch" -f
}

case "${1:-build}" in
fetch) fetch ;;
build) build ;;
commit-db) commitDB ;;
*)
  echo "usage: $0 {fetch|build|commit-db}" >&2
  exit 2
  ;;
esac
