System logs are where a huge amount of real operational evidence lives.
The point is not to stare at every line until your eyes glaze over.
The point is to filter the stream until only the interesting events remain.

In this room, `night.log` is small enough to read by hand, but that is not the skill being trained.
You are practicing how to isolate successful authentication events and pull the last one quickly.

**Your task:**
Inspect the log format, isolate the `AUTH OK` lines, identify the last successful authentication entry, and submit the answer from that line with:

```bash
./submit ANSWER
```
