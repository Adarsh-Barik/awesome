#! /usr/bin/python
##
# @file score.py
# @Description fetches score from cricinfo website for a given match link
# @author Adarsh Barik
# @version 1
# @date 2013-03-07

import os
from BeautifulSoup import BeautifulSoup as Soup

#url='https://www.espncricinfo.com/new-zealand-v-england-2013/engine/current/match/569243.html'
ashes = "wget -O match.html http://www.espncricinfo.com/the-ashes-2013/engine/match/566932.html"
os.system(ashes)
match = open('match.html').read()
soup = Soup(match)
title = soup.findAll('title')
t=str(title[0]).split()
score = [t[0][7:],t[1],t[2][1:],t[5],t[6],t[8],t[9],t[11],t[12][:-1]]
score = ' '.join(score)
print score
