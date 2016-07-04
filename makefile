test:
	echo "Just getting the Bulbasaur family"
	./get_gifs.sh 1 3

gen1:
	echo "Getting all first-generation Pokemon"
	./get_gifs.sh 1 151

gen2:
	echo "Getting all second-generation Pokemon"
	./get_gifs.sh 152 251

gen3:
	echo "Getting all third-generation Pokemon"
	./get_gifs.sh 252 386

gen4:
	echo "Getting all fourth-generation Pokemon"
	./get_gifs.sh 387 493

gen5:
	echo "Getting all fifth-generation Pokemon"
	./get_gifs.sh 494 649

# The sprite website doesn't have sixth-generation yet
# gen6:
# 	echo "Getting all sixth-generation Pokemon"
# 	./get_gifs.sh 650 721
