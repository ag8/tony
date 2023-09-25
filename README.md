# tony: a command-line tool which'll tell ya what yer doin' wrong

## Installation instructions

1. Download `fixit.sh`:

`wget https://raw.githubusercontent.com/ag8/tony/main/fixit.sh`

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

3. Make sure your `OPENAI_API_KEY` environment variable is set

4. `source .bashrc`

## Usage

Got problems? Ask tony!

![alt text](https://github.com/ag8/tony/blob/main/tony-output.png?raw=true)


