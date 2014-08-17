from pygenius import songs
import re
import os

artist = raw_input("Please enter artist: ")
title = raw_input("Please enter song title: ")

filename = "LYRIC-FILES/" + artist + "-" + title + ".txt"

file = open(filename, "w")

song = []

lyrics = songs.searchSong(artist, title, "lyrics")

for lyric in lyrics:
	lyric = lyric.strip().replace('\n', ' ').replace('(', '').replace(')', '')
	r = re.search(r'\[(.+?)', lyric)
	if r == None:
		words = lyric.split(' ')
		for word in words:
			song.append(word)

for word in song:
	file.write(word)

file.close()

print "File is saved at " + filename
