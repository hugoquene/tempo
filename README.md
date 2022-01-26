# tempo

speech tempo measurement in Praat

This is a modified version of the script named Praat Script Syllable Nuclei 
Copyright (C) 2008  Nivja de Jong and Ton Wempe

The script only works with Praat software (www.praat.org). 

This version has been modified by Hugo Quené (h.quene@uu.nl) in several ways:
- 2010: arguments are pre-set within the script
- 2010: script does not loop over all files in directory, only applies on interactively selected Sound
- 2010: several changes in audio measurements
- 2022: does not only work on entire file but also reports tempo for each interval of interval tier of associated TextGrid

Sample of output:

This was produced using intervals on tier 1 (which were created by choosing _Sound: To Textgrid (silences)..._ with default settings, which however are not optimal for this audio recording): 
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
