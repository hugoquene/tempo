###########################################################################
#                                                                         #
#  Praat Script Syllable Nuclei                                           #
#  Copyright (C) 2008  Nivja de Jong and Ton Wempe                        #
#                                                                         #
#    This program is free software: you can redistribute it and/or modify #
#    it under the terms of the GNU General Public License as published by #
#    the Free Software Foundation, either version 3 of the License, or    #
#    (at your option) any later version.                                  #
#                                                                         #
#    This program is distributed in the hope that it will be useful,      #
#    but WITHOUT ANY WARRANTY; without even the implied warranty of       #
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the        #
#    GNU General Public License for more details.                         #
#                                                                         #
#    You should have received a copy of the GNU General Public License    #
#    along with this program.  If not, see http://www.gnu.org/licenses/   #
#                                                                         #
# 
###########################################################################
#
# modified 2010.03.04 by Hugo Quené, Utrecht University
# for practical work in "Melodie en Ritme in Talen" course. 
# Overview of changes: 
# + work only on single currently selected sound, 
#   and do NOT retrieve and process multiple sounds (names) from file list
# + pre-set parameter values instead of providing these interactively
#    and bypass longer parameter names in interactive form
# + remove max number of syllable nuclei
# + script name changed to tempo
# + refer to objects by unique identifier, not by name
# + keep track of all created intermediate objects, select these explicitly, 
#     then Remove
# + provide summary output in Info window
# 
# further modified 20100308 by HQ
# + check that exactly one Sound is selected at startup
# + allow Sound to have starting time different from zero
#   for Sound objects created with Extract (preserve times)
# + in output, do not write column names and units, only comma-separated values
# + in first line of output, write column names and units.
# 
# modified 20220120 by HQ
# + check that exactly one Sound and one Textgrid is selected at startup
#   the TG must contain an interval tier
# + provide summary findings for each interval on the interval tier
#   to do: these could be filtered to include or exclude particular labels
# modified 20220126 by HQ
# + if the Sound has >1 channels, then first convert to mono
###########################################################################

# counts syllables of all sound utterances in a directory
# HQ: Count syllables of single selected Sound utterance in Praat list of objects

# NB unstressed syllables are sometimes overlooked
# NB filter sounds that are quite noisy beforehand
# NB use Ignorance Level/Intensity Median (dB) = 0 for unfiltered sounds,
#    use 2 for filtered sounds
# NB use Minimum dip between peaks (dB) = 2 for unfiltered sounds,
#    use 4 for filtered sounds
# HQ: Do not enter parameters interactively, but set these in script;
#     do not set long parameters and convert to short form, but set
#     short form directly. 
# ignorance_Level/Intensity_Median = 0
# minimum_dip_between_peaks = 2
# HQ: Do not enter parameters interactively, but set these in script
#form Counting Syllables in Sound Utterances
#   real Ignorance_Level/Intensity_Median_(dB) 0 or 2
#   positive Max_number_of_syllables_per_Sound 700
#   real Minimum_dip_between_peaks_(dB) 2 or 4
#   boolean display_name yes
#   sentence directory C:\directorywithsoundfiles
#endform
# shorten variables
# iglevel = 'ignorance_Level/Intensity_Median'
iglevel = 3
# HQ: not used:
#    maxsyl = 'max_number_of_syllables_per_Sound'
# mindip = 'minimum_dip_between_peaks'
mindip = 3

# HQ: Do NOT retrieve file names automatically from file list
#Create Strings as file list... list 'directory$'\*.wav
#numberOfFiles = Get number of strings
#for ifile to numberOfFiles
#   select Strings list
#   fileName$ = Get string... ifile
#   Read from file... 'directory$'\'fileName$'

# at this point, a single sound must be selected
if ( numberOfSelected("Sound") != 1 )
	exit Select a single Sound object.
endif
# no "else" is necessary

## begin addition 20220120
if ( numberOfSelected("TextGrid") != 1 )
	exit Select a single TextGrid object.
endif
# no "else" is necessary
# note that there is no check about whether the Sound and TextGrid do match! 
## end addition 20220120

## bypassed 20220120
   # HQ: print a single header line with column names and units
#    printline #
#    printline # sound, textgrid, nsyll (syll), dur (s), tempo (syll/s), ASD (s/syll)
## end bypass 20220120

   # use object ID, not object name, see Praat help
   soundname$ = selected$("Sound")
   soundid = selected("Sound")

   # use object ID, not object name, see Praat help
   tgname$ = selected$("TextGrid")
   tgid = selected("TextGrid")
   
## added 20220120
   select 'soundid'

   # sr = Get sample rate
   sr = Get sampling frequency
   # stay some distance from nyquist
   bw = sr * 0.45

   originaldur = Get total duration
   # allow non-zero starting time
   bt = Get starting time

## added 20220126
   nchannels = Get number of channels
   if (nchannels>1)
		Convert to mono
		printline Sound 'soundname$' converted to mono!
		# update pointers to selected Sound
	    soundname$ = selected$("Sound")
	    soundid = selected("Sound")
   endif
## end addition

   # mean is also subtracted in To Intensity...
   # Subtract mean

   # Use intensity to get threshold
   To Intensity... 50 0 yes
   intid = selected("Intensity")
   start = Get time from frame number... 1
   nframes = Get number of frames
   end = Get time from frame number... 'nframes'

   # estimate noise floor
   minint = Get minimum... 0 0 Parabolic
   # estimate noise max
   maxint = Get maximum... 0 0 Parabolic
   #get median of Intensity: limits influence of high peaks
   medint = Get quantile... 0 0 0.5

   # estimate Intensity threshold
   threshold = medint + iglevel
   if threshold < minint
       threshold = minint
   endif

   # HQ: remember id's of all created objects
   Down to Matrix
   matid = selected("Matrix")
   # Convert intensity to sound
   To Sound (slice)... 1
   # Rename... int
   # HQ: refer by id not by name
   sndintid = selected("Sound")

   # HQ: use total duration, not end time, to find out duration of intdur
   #     in order to allow nonzero starting times!!
   # intdur = Get finishing time
   intdur = Get total duration
   intmax = Get maximum... 0 0 Parabolic

   # estimate peak positions (all peaks)
   # presumably this should yield extremes in intensity contour
   To PointProcess (extrema)... Left yes no Sinc70
   ppid = selected("PointProcess")

   numpeaks = Get number of points

   # fill array with time points
   for i from 1 to numpeaks
       t'i' = Get time from index... 'i'
   endfor

   # fill array with intensity values
   # select Sound int
   select 'sndintid'
   peakcount = 0
   for i from 1 to numpeaks
       value = Get value at time... t'i' Cubic
       if value > threshold
             peakcount += 1
             int'peakcount' = value
             timepeaks'peakcount' = t'i'
       endif
   endfor

   # fill array with valid peaks: only intensity values if preceding
   # dip in intensity is greater than mindip
   # select Intensity 'obj$'
   select 'intid'
   validpeakcount = 0
   precedingtime = timepeaks1
   precedingint = int1
   for p to peakcount-1
      following = p + 1
      followingtime = timepeaks'following'
      dip = Get minimum... 'precedingtime' 'followingtime' None
      diffint = abs(precedingint - dip)
      if diffint > mindip
         validpeakcount += 1
         validtime'validpeakcount' = timepeaks'p'
         precedingtime = timepeaks'following'
         precedingint = Get value at time... timepeaks'following' Cubic
      endif
   endfor

   # Look for only voiced parts
   # select Sound 'obj$'
   select 'soundid' 
   To Pitch (ac)... 0.02 30 4 no 0.03 0.25 0.01 0.35 0.25 450
   # keep track of id of Pitch
   pitchid = selected("Pitch")

   voicedcount = 0
   for i from 1 to validpeakcount
      querytime = validtime'i'

      value = Get value at time... 'querytime' Hertz Linear

      if value <> undefined
         voicedcount = voicedcount + 1
         voicedpeak'voicedcount' = validtime'i'
      endif
   endfor


   # stop if too many syllables are found
   #if voicedcount > maxsyl
   #    pause 'obj$': Number of syllabes exceeds 'maxsyl'!
   #    exit
   #endif
  
   # calculate time correction due to shift in time for Sound object versus
   # intensity object
   timecorrection = originaldur/intdur

   # Insert voiced peaks in second Tier
   # select Sound 'obj$'
## 20220120 not needed
   # select 'soundid'

## changed 20220120
## instead of creating a new TextGrid, use the one selected at the start. 
## add a tier named "syllables" at the bottom (!)
#   To TextGrid... "syllables" syllables
#   for i from 1 to voicedcount
#       position = voicedpeak'i' * timecorrection
#       Insert point... 1 position 'i'
#   endfor
#   nrsylls = Get number of points... 1
    select 'tgid'
	ntiers = Get number of tiers
	lasttier = ntiers+1
	Insert point tier... 'lasttier' syllables
    for i from 1 to voicedcount
       position = voicedpeak'i' * timecorrection
       Insert point... 'lasttier' position 'i'
    endfor
    nrsylls = Get number of points... 'lasttier'
## end modification 20220120

   # HQ: keep TextGrid for inspection, do not save.
   # write textgrid to textfile
   # Write to text file... 'directory$'\'obj$'.syllables.TextGrid


# HQ: !! NOTE that the following is a dangerous step in the original script, 
#     and should only be used with great caution. 
#     The next few command lines would remove all objects that were already 
#     in the objects list at the time this script was called. 
    # clean up before next sound file is opened
    #   select all
    #   minus Strings list
    select 'intid'
    plus 'matid'
    plus 'sndintid'
    plus 'ppid'
    plus 'pitchid'
    # are you sure?
    Remove

   # HQ: summarize results in Info window
   temp1 = 'nrsylls'/'originaldur'
   temp2 = 'originaldur'/'nrsylls'

## addition 20220120
    printline # 
	printline # for entire Sound:
    printline # sound, textgrid, nsyll (syll), dur (s), tempo (syll/s), ASD (s/syll)
	printline 'soundname$', 'tgname$', 'nrsylls', 'originaldur:3', 'temp1:2', 'temp2:3'
## end addition 20220120

## addition 20220120
   printline # 
   select 'tgid'
## !! in the next line, the appropriate interval tier should be specified !! 
## (in an interactive version, this might be queried from user
## or passed on as argument when calling the script)
   inttier = 8
   inttier$ = Get tier name... 'inttier'
   isinttier = Is interval tier... 'inttier'
   if 'isinttier'=1
	 printline # for intervals on tier 'inttier' ('inttier$'):
     nrintervals = Get number of intervals... 'inttier'
  	 printline # sound, textgrid, intervaltier, interval, label, nsyll, dur, tempo (syll/s), ASD (s/syll)
     for i from 1 to 'nrintervals'
		bt = Get start time of interval... 'inttier' 'i'
		et = Get end time of interval... 'inttier' 'i'
		intdur = et-bt
		firstpoint = Get high index from time... 'lasttier' 'bt'
		lastpoint = Get low index from time... 'lasttier' 'et'
		if 'lastpoint'>'firstpoint'
			nrsylls = 'lastpoint'-'firstpoint'+1 
		else 
			nrsylls=0
		endif
		intlabel$ = Get label of interval... 'inttier' 'i'
		temp1 = 'nrsylls'/'intdur'
		if 'nrsylls'>0
			temp2 = 'intdur'/'nrsylls' 
		else 
			temp2 = 0
		endif
  	   # for each interval in the selected interval tier, report the tempo
		printline 'soundname$', 'tgname$', 'inttier', 'i', 'intlabel$', 'nrsylls', 'intdur:3', 'temp1:2', 'temp2:3'
     endfor
   else 
		printline Tier 'inttier' in TextGrid 'tgid' is not an interval tier! 
   endif
## end addition 20220120

# endfor : for each input sound

# end of script

# printline Success!