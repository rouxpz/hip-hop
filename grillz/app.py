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

		lyric = lyric.replace('\n', ' ').replace('(', '').replace(')', '').replace(',', '').replace('-', ' ')
		lyric = lyric.strip()
		
		words = lyric.split(' ')

		for word in words:
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
		for p in poverty:
			r = re.search(p, word)
			if r != None:
				if i >= 10 or i <= len(song)-10:
					for j in range(i-10, i+10):
						if j != i:
							comparison = song[j].lower()
							for w in wealth:
								r1 = re.search(w, comparison)
								if r1 != None:
									# print comparison
									score += abs(j-i)
									score = 1/score
									scores.append(score)
				#print word and score
				# print word + ": Poverty, " + str(score)
				continue

			elif r == None:
				compound = [word, nextWord]
				compound = ' '.join(compound)
				e = re.match(p, compound)
				if e != None:
					if i >= 10 or i <= len(song)-10:
						for j in range(i-10, i+11):
							if j != i and j != i+1:
								comparison = song[j].lower()
								for w in wealth:
									r1 = re.search(w, comparison)
									if r1 != None:
										# print comparison
										score += abs(j-i)
										score = 1/score
										scores.append(score)
					# print compound + ": Poverty, " + str(score)
					continue

		for w2 in wealth:
			r = re.search(w2, word)
			if r != None:
				if i >= 10 or i <= len(song)-10:
					for j in range(i-10, i+10):
						if j != i:
							comparison = song[j].lower()
							for p in poverty:
								r1 = re.search(p, comparison)
								if r1 != None:
									score += abs(j-i)
									score = 1/score
									scores.append(score)
				# print word + ": Wealth, " + str(score)
				continue

			elif r == None:
				compound = [word, nextWord]
				compound = ' '.join(compound)
				e = re.match(w2, compound)
				if e != None:
					if i >= 10 or i <= len(song)-10:
						for j in range(i-10, i+11):
							if j != i and j != i+1:
								comparison = song[j].lower()
								for p in poverty:
									r1 = re.search(w, comparison)
									if r1 != None:
										# print comparison
										score += abs(j-i)
										score = 1/score
										scores.append(score)
					# print compound + ": Wealth, " + str(score)
					continue

		# scores.append(score)
		scored = word + "," + str(score)
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

