from pygenius import songs

lyrics = songs.searchSong("raekwon", "ice cream", "lyrics")

for lyric in lyrics:
	print lyric