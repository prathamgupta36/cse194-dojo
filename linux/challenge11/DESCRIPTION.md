File timestamps are often treated like boring metadata until you need to reconstruct what happened and when.
Then they become evidence.

This room is about using the filesystem as a timeline.
The incident window is bounded by two marker files, and one evidence file was modified during that window.
The puzzle is the timestamps themselves, not a hidden string format waiting to be grepped.

**Your task:**
Use `window_open.marker` and `window_close.marker` to identify the evidence file modified during the incident window, recover the codename inside it, and verify the answer with:

```bash
./submit ANSWER
```
