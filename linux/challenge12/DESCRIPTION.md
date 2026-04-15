The command line gets interesting when several small Unix ideas meet each other.
This capstone is built around three of them: command lookup through `PATH`, files whose names lie about their contents, and symlink trails that only make sense once you resolve them correctly.

Nothing here requires programming.
It does require that you reuse the habits from the earlier rooms instead of treating each trick as isolated trivia.

**Your task:**

1. Enter the local night-shift shell:

   ```bash
   . ./activate
   ```

2. Figure out where the `dispatch` command is coming from and run it.
3. Inspect the fake image in `cache/` and recover its clue word.
4. Resolve the symlink trail starting at `cathedral/entryway`.
5. Reveal the hidden helper in `ops/maintenance`.
6. Run that helper with the three clue words in the correct order.