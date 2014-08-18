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
	r = re.search(r'\[(.+?)\]', lyric)
	# if r == None:

	if r != None:
		# print lyric
		delete = r.group(0)
		lyric = lyric.replace(delete, '')

		rnew = re.search(r'\[(.+?)\]', lyric)

		if rnew != None:
			deletenew = rnew.group(0)
			lyric = lyric.replace(deletenew, '')

		else:
			pass

	else:
		pass

	lyric = lyric.replace('\n', ' ').replace('(', '').replace(')', '').replace(',', '')
	lyric = lyric.strip()
	
	words = lyric.split(' ')

	for word in words:
		song.append(word)
	
# print song

for word in song:
	file.write(word)
	file.write(" ")

file.close()

print "File is saved at " + filename
