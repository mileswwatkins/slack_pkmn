#!/bin/bash

mkdir -p pkmn
MAX_DIMENSION="128"
MAX_FILESIZE="64000"
SAFE_DIMENSION="40"

# Download and process GIFs to be ready for Slack
for pkmn_num in `seq -f "%03g" 6 9`; do
	GIF_LOCATION=pkmn/${pkmn_num}.gif
	wget http://sprites.pokecheck.org/i/${pkmn_num}.gif \
		 --quiet --output-document pkmn/${pkmn_num}.gif \
		 # --no-clobber

	# Slack has limits of 64KB in filesize limit, and 128 pixels high and wide
	# Trim dimensions, if necessary
	gifsicle --crop-transparency --resize-fit "$MAX_DIMENSION"x"$MAX_DIMENSION" \
		"$GIF_LOCATION" --output "$GIF_LOCATION"

	# Decrease file sizes if they're too big
	FILESIZE=$(wc -c <"$GIF_LOCATION" 2>/dev/null)
	if [ "$FILESIZE" -gt "$MAX_FILESIZE" ]; then
		gifsicle --crop-transparency --resize-fit "$SAFE_DIMENSION"x"$SAFE_DIMENSION" \
			"$GIF_LOCATION" --output "$GIF_LOCATION"
		mkdir -p pkmn/exploded
		mv "$GIF_LOCATION" pkmn/exploded/full.gif
		cd pkmn/exploded
		gifsicle --unoptimize --disposal=background  --delay=10 --explode full.gif
		rm full.gif.*[13579] full.gif
		gifsicle * > halfsize.gif
		gifsicle halfsize.gif  --optimize=3 --output halfsize.gif
		cd ../..
		mv pkmn/exploded/halfsize.gif "$GIF_LOCATION"
		rm -rf pkmn/exploded
	fi

	NEW_FILESIZE=$(wc -c <"$GIF_LOCATION" 2>/dev/null)
	if [ "$NEW_FILESIZE" -gt "$MAX_FILESIZE" ]; then
		echo "Filesize still too large, for Pokemon #${pkmn_num}"
		echo "Decrease the SAFE_DIMENSION value, or drop more frames"
		exit 1
	fi
done
