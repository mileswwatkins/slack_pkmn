Slack PKMN
---

Add animated Pokemon as custom emoji to your Slack.

Images sourced using [the PokeAPI](https://github.com/PokeAPI/pokeapi).

#### Requirements

- `gifsicle`
- `wget`
- `make`

#### Test it out

Test my tool out on just a few Pokemon:

```
make test
```

#### Catch 'em all

First, grab whichever Pokemon you want:

```bash
# "Only the original 151 were real Pokemon!"
make gen1
```

or

```bash
# "I only like games evenly divisible by two!"
make gen2
make gen4
make gen6
```

or

```bash
# "Only Pikachu and Raichu, please!"
./get_gifs.sh 25 26
```

Then, POST the GIFs to Slack, using a tool such as https://github.com/smashwilson/slack-emojinator

```bash
git clone https://github.com/smashwilson/slack-emojinator.git
cd slack-emojinator
mkvirtualenv slack-emojinator
pip install -r requirements.txt

# Store your Slack's team name and most recent cookie in environment variables
export SLACK_TEAM=${YOUR_TEAM_NAME}
export SLACK_COOKIE=${YOUR_SLACK_COOKIE}
python upload.py ../pkmn/*
```
