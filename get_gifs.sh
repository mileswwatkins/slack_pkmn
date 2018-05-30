#!/bin/bash

set -e

PKMN_DIR="pkmn"
NAMESPACE="pkmn-"
MAX_FILESIZE="64000"
MAX_DIMENSION="128"
SAFE_DIMENSION="40"

# Download and process GIFs to be ready for Slack
mkdir -p $PKMN_DIR
# Handle the case where only one Pokemon number is entered
for pkmn_num in $(seq -f "%03g" "$1" "${2:-$1}"); do
	# Name the emoji properly
	PKMN_NAME="$(wget --quiet --output-document=- "http://pokeapi.co/api/v2/pokemon/${pkmn_num}" | jq --raw-output '.name')"

	GIF_LOCATION="${PKMN_DIR}/${NAMESPACE}${PKMN_NAME}.gif"
	wget "http://sprites.pokecheck.org/i/${pkmn_num}.gif" \
		 --quiet --output-document "$GIF_LOCATION" \
		 --no-clobber

	# Slack has limits of 64KB, and 128x128 pixels
	# Trim dimensions, if necessary
	gifsicle --crop-transparency --resize-fit "$MAX_DIMENSION"x"$MAX_DIMENSION" \
		"$GIF_LOCATION" --output "$GIF_LOCATION"

	# Decrease file size if a GIF's still too big
	FILESIZE=$(wc -c <"$GIF_LOCATION" 2>/dev/null)
	if [ "$FILESIZE" -gt "$MAX_FILESIZE" ]; then
		gifsicle --crop-transparency --resize-fit "$SAFE_DIMENSION"x"$SAFE_DIMENSION" \
			"$GIF_LOCATION" --output "$GIF_LOCATION"
		mkdir -p ${PKMN_DIR}/exploded
		mv "$GIF_LOCATION" ${PKMN_DIR}/exploded/full.gif
		cd ${PKMN_DIR}/exploded
		gifsicle --unoptimize --disposal=background  --delay=10 --explode full.gif
		rm full.gif.*[13579] full.gif
		gifsicle ./* > halfsize.gif
		gifsicle halfsize.gif  --optimize=3 --output halfsize.gif
		cd ../..
		mv ${PKMN_DIR}/exploded/halfsize.gif "$GIF_LOCATION"
		rm -rf ${PKMN_DIR}/exploded
	fi

	NEW_FILESIZE=$(wc -c <"$GIF_LOCATION" 2>/dev/null)
	if [ "$NEW_FILESIZE" -gt "$MAX_FILESIZE" ]; then
		echo "Filesize still too large, for ${PKMN_NAME} (#${pkmn_num})"
		echo "Decrease the SAFE_DIMENSION value, or drop more frames"
		rm "$GIF_LOCATION"
		exit 1
	fi

	echo "go, ${PKMN_NAME}!!"
done
echo "caught 'em all!"
