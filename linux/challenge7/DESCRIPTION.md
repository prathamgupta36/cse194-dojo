A symbolic link is not the file itself.
It is a filesystem object that points somewhere else, which means symlinks can form clean shortcuts, absurd detours, dead ends, or loops.

This cathedral contains all of those.
There is one real chain, one broken chain, and one loop, and the challenge is to tell the difference without wandering forever.
The slow solve is to trace the links by hand with listings.
The elegant solve is to let Linux resolve the path for you.

**Your task:**
Start from anywhere you want, determine which chain resolves to a real note, recover the answer at the end of the real chain, and verify it with:

*Hint* - See how to follow links in linux.

```bash
./submit ANSWER
```
