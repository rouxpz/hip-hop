from pygenius import songs

lyrics = songs.searchSong("wu tang clan", "cream", "lyrics")

for lyric in lyrics:
	print lyric