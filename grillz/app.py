from pygenius import songs
import re
import os

artist = raw_input("Please enter artist: ")
title = raw_input("Please enter song title: ")

song = []
keys = []

def keyPhrases(category):

	file = open('dictionaries/' + category + '.txt', 'r')
	phrases = file.read()
	phrases = phrases.split('\n')
	keys.append(phrases)
	file.close()

# print poverty
# print wealth

def getLyrics():

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

		lyric = lyric.replace('\n', ' ').replace('(', '').replace(')', '').replace(',', '').replace('-', ' ')
		lyric = lyric.strip()
		
		words = lyric.split(' ')

		for word in words:
			song.append(word)

def analyzeSong():
	filename = "LYRIC-FILES/" + artist + "-" + title + ".txt"

	file = open(filename, "w")

	for word in song:
		file.write(word)
		file.write(" ")

	file.close()

	print "File is saved at " + filename



keyPhrases("poverty")
keyPhrases("wealth")

poverty = keys[0]
wealth = keys[1]

# print poverty
# print wealth

getLyrics()
analyzeSong()

# print song

