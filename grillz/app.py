from pygenius import songs
import re
import os

artist = raw_input("Please enter artist: ")
title = raw_input("Please enter song title: ")

song = []
keys = []
scores = []

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

		lyric = lyric.replace('\n', ' ').replace('(', '').replace(')', '').replace(',', '').replace('-', ' ').replace('...', '')
		lyric = lyric.strip()
		
		words = lyric.split(' ')

		for word in words:
			if word != '':
				song.append(word)

	print "Song collected!"

def analyzeSong():

	# open file to store score data
	filename = "LYRIC-FILES/" + artist + "-" + title + ".txt"
	file = open(filename, "w")

	# scoring poverty words
	for i in range(0, len(song)-1):
		word = song[i].lower()
		nextWord = song[i+1].lower()
		score = 0.0
		collect = False
		for p in poverty:
			r = re.search(p, word)
			if r != None:
				collect = True
				if i >= 10 or i <= len(song)-10:
					for j in range(i-10, i+10):
						if j != i:
							comparison = song[j].lower()
							for w in wealth:
								r1 = re.search(w, comparison)
								if r1 != None:
									# print comparison
									toAdd = float(abs(j-i))
									# print toAdd
									toAdd = 1/toAdd
									score += toAdd

			elif r == None:
				compound = [word, nextWord]
				compound = ' '.join(compound)
				e = re.match(p, compound)
				if e != None:
					collect = True
					if i >= 10 or i <= len(song)-10:
						for j in range(i-10, i+11):
							if j != i and j != i+1:
								comparison = song[j].lower()
								for w in wealth:
									r1 = re.search(w, comparison)
									if r1 != None:
										# print comparison
										toAdd = float(abs(j-i))
										# print toAdd
										toAdd = 1/toAdd
										score += toAdd

		for w2 in wealth:
			r = re.search(w2, word)
			if r != None:
				collect = True
				if i >= 10 or i <= len(song)-10:
					for j in range(i-10, i+10):
						if j != i:
							comparison = song[j].lower()
							for p in poverty:
								r1 = re.search(p, comparison)
								if r1 != None:
									toAdd = float(abs(j-i))
									toAdd = 1/toAdd
									# print toAdd
									score += toAdd

			elif r == None:
				compound = [word, nextWord]
				compound = ' '.join(compound)
				e = re.match(w2, compound)
				if e != None:
					collect = True
					if i >= 10 or i <= len(song)-10:
						for j in range(i-10, i+11):
							if j != i and j != i+1:
								comparison = song[j].lower()
								for p in poverty:
									r1 = re.search(w, comparison)
									if r1 != None:
										# print comparison
										toAdd = float(abs(j-i))
										# print toAdd
										toAdd = 1/toAdd
										score += toAdd
		if collect == True:
			scores.append([word, score])

	# scores.append(score)
	for k in range(0, len(scores)):
		scored = scores[k][0] + ", " + str(scores[k][1])
		file.write(scored)
		file.write("\n")

	file.close()

	print "File is saved at " + filename



keyPhrases("poverty")
keyPhrases("wealth")

poverty = keys[0]
wealth = keys[1]

# print poverty

getLyrics()
analyzeSong()

print len(scores)

