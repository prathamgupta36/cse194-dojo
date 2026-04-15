On Unix, "existing" and "readable" are not the same thing.
A directory can be full of interesting-looking files while your current user only has permission to open one of them.

This room is about treating permissions as data.
Most of the clues under `mirage/` are there to waste your time if you search by content alone.
The real question is which file your user can actually read.

**Your task:**
Inspect the files under `mirage/`, identify the clue file that is genuinely readable by your user, recover the answer from it, and verify it with:

```bash
./submit ANSWER
```
