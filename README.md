# tony: a command-line tool which'll tell ya what yer doin' wrong

## Installation instructions

1. Download `fixit.sh`:

``

2. Add the following to your `.bashrc` file:

```bash
shopt -s histverify

tony() {
  # Get the second-to-last command from the history
  LAST_CMD=$(history | tail -n 2 | head -n 1 | sed 's/^[ \t]*[0-9]*[ \t]*//')
  # Execute the last command and capture the output
  CMD_OUTPUT=$(eval $LAST_CMD 2>&1)
  
  # Call the fixit.sh script with the last command and its output as arguments
  ~/fixit.sh "$LAST_CMD" "$CMD_OUTPUT"
}
```
