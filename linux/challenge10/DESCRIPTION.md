Unix programs do not have just one output stream.
They normally speak on stdout, but warnings, complaints, and diagnostics often go to stderr instead.
If you ignore that distinction, you miss information that the system is actively trying to show you.

This room is built around that mistake.
`./oracle` looks unhelpful at first because the clue is not being printed where most people look first.

**Your task:**
Run `./oracle`, separate stdout from stderr, recover the answer from the error stream, and verify it with:

```bash
./submit ANSWER
```
