# Working in this repo

- Keep the local Rails/puma dev server running once it's started — don't `pkill`/stop it
  after using it to verify a change in the browser. It stays up across sessions; killing it
  is unwanted churn.
