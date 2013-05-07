#!/usr/bin/env python
##
# @file pname.py
# @Description Renames the pdf files in a directory
# @author Adarsh Barik
# @version 1
# @date 2013-01-15

from pyPdf import PdfFileWriter, PdfFileReader
import os
import sys
from optparse import OptionParser

def Rename_All():
	"""renames all the file in the current directory"""
	for fileName in os.listdir('.'):
  		if fileName.lower()[-3:] != "pdf":
			continue
  		try:
    			actfile = file(fileName, "rb")
    			input1 = PdfFileReader(actfile)
			if input1.getDocumentInfo().title==u'':
				continue
   			trgtfilename = input1.getDocumentInfo().title + "_" + '_'.join(input1.getDocumentInfo().author.split(';'))+".pdf"
  		except:
			print "\n %s -> Error: Title could not be extracted. PDF file may be encrypted." % fileName
    			continue
 
  		del input1
  		actfile.close()

  		print "\n %s -> %s"% (fileName, trgtfilename) 
  		try:
    			os.rename(fileName,trgtfilename)
  		except:
    			print fileName, ' could not be renamed!'
    			print '\n Error: are prior names unique? Maybe the filename already exists or the document is already opened.'

def Rename_File(options,filepath):
	"""
	renames the files with given options
	"""
	fileName = os.path.basename(filepath)
	if options.all:
		Rename_All()
	else:
		if fileName.lower()[-3:] != "pdf":
			return 0
  		try:
    			actfile = file(fileName, "rb")
    			input1 = PdfFileReader(actfile)
			if input1.getDocumentInfo().title==u'':
				return 0
   			trgtfilename = input1.getDocumentInfo().title + "_" + '_'.join(input1.getDocumentInfo().author.split(';'))+".pdf"
  		except:
			print "\n %s -> Error: Title could not be extracted. PDF file may be encrypted." % fileName
    			return 0
 
  		del input1
  		actfile.close()

  		print "\n %s -> %s"% (fileName, trgtfilename) 
  		try:
    			os.rename(fileName,trgtfilename)
  		except:
    			print fileName, ' could not be renamed!'
    			print '\n Error: are prior names unique? Maybe the filename already exists or the document is already opened.'

if __name__=="__main__":
	""" parses the command-line and renames the files parsed in"""
	# create the options we want to parses
	usage = "usage: %prog [options] file1 ... fileN"
	optParser = OptionParser(usage=usage)
	optParser.add_option("-a", "--all", action="store_true", dest="all", default=False, help="Rename all the files")
	(options, args) = optParser.parse_args()
	# check that they passed in atleast one file to rename
	if len(args)<1 and options.all:
		args =['yes']

	# loop though the files and rename them
	for filename in args:
		Rename_File(options, filename)
	# exit successful
	sys.exit(0)
	

		





