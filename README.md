# tempo

Brief description: script for measuring speech tempo in Praat. 

This is a modified version of the script named "Praat Script [for] Syllable Nuclei",  
Copyright (C) 2008  Nivja de Jong and Ton Wempe.

The original script was reported in:

De Jong, N.H. & Wempe, T. (2009). 
Praat script to detect syllable nuclei and measure speech rate automatically. 
Behavior Research Methods, volume 41, pages 385–390.

The modified script creates an intensity contour of a speech fragment (a Sound must have been selected before calling the script), and then looks for peaks in the intensity contour, which presumably coincide with nuclei of syllables in the speech sound. The syllable nuclei are collected as points in a new "point tier" added at the bottom of the TextGrid (the TextGrid associated with the Sound must also have been selected before calling the script). 
Tempo is then expressed as the number of syllables per second (syll/s) or as the "average syllable duration" (ASD, s/syll), for each interval of a particular interval tier of the TextGrid. 

The version in this repository has been modified by Hugo Quené (h.quene@uu.nl) in several ways:
- 2010: arguments are pre-set within the script
- 2010: script does not loop over all files in directory, only applies on interactively selected Sound
- 2010: several changes in audio measurements
- 2022: does not only work on entire file but also reports tempo for each interval of interval tier of associated TextGrid

The script requires a running instance of Praat (www.praat.org). 

## Sample of output:

This output was produced using intervals on tier 1 (the interval tier was created by choosing _Sound: To Textgrid (silences)..._ with default settings, which however are not optimal for this example speech recording): 
```
# for entire Sound:
# sound, textgrid, nsyll (syll), dur (s), tempo (syll/s), ASD (s/syll)
kh-ckh-20210921-idwt5havx-web-hd, kh-ckh-20210921-idwt5havx-web-hd, 3590, 1273.684, 2.82, 0.355
# 
# for intervals on tier 1 (silences):
# sound, textgrid, intervaltier, interval, label, nsyll, dur, tempo (syll/s), ASD (s/syll)
...
kh-ckh-20210921-idwt5havx-web-hd, kh-ckh-20210921-idwt5havx-web-hd, 1, 9, silent, 0, 0.950, 0, 0
kh-ckh-20210921-idwt5havx-web-hd, kh-ckh-20210921-idwt5havx-web-hd, 1, 10, sounding, 8, 2.040, 3.92, 0.255
kh-ckh-20210921-idwt5havx-web-hd, kh-ckh-20210921-idwt5havx-web-hd, 1, 11, silent, 0, 1.490, 0, 0
kh-ckh-20210921-idwt5havx-web-hd, kh-ckh-20210921-idwt5havx-web-hd, 1, 12, sounding, 12, 2.100, 5.71, 0.175
kh-ckh-20210921-idwt5havx-web-hd, kh-ckh-20210921-idwt5havx-web-hd, 1, 13, silent, 2, 1.140, 1.75, 0.570
kh-ckh-20210921-idwt5havx-web-hd, kh-ckh-20210921-idwt5havx-web-hd, 1, 14, sounding, 6, 1.540, 3.90, 0.257
```
