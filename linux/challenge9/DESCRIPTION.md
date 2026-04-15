A filename is not the same thing as a file.
On Unix, multiple directory entries can point at the same underlying inode, which means one note can appear to have several different identities.

This room is about hard links and inode identity.
The cleanest solves notice matching inode numbers or explicitly search for files that share the same underlying data.

**Your task:**
Figure out which files are really the same file, recover the shared note, and verify the answer with:

```bash
./submit ANSWER
```
