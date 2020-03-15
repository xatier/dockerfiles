# Dockerfiles

My Dockerfile collections.

This is my collection of Dockerfile.
I used to have the following dockerfiles, now consolidate them to one single repo for all kinds.

- [popcorn-docker](https://github.com/xatier/popcorn-docker)
- [diffoscope-arch](https://github.com/xatier/diffoscope-arch)

## Preserve the history

I do the following trick to preserve the commit history from the other repos.

```bash
git remote add diffoscope git@github.com:xatier/diffoscope-arch.git
git pull diffoscope --allow-unrelated-histories  master --no-rebase
mv Dockerfile diffoscope-arch/
git add .
git commit
git remote rm diffoscope
```

Please see the README.md files inside each directory for details of each image.