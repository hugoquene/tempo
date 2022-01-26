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

```
Sound w10118con converted to mono!
# 
# for entire Sound:
# sound, textgrid, nsyll (syll), dur (s), tempo (syll/s), ASD (s/syll)
w10118con_mono, w10118con, 2165, 912.491, 2.37, 0.421
# 
# for intervals on tier 8 (IPUbs):
# sound, textgrid, intervaltier, interval, label, nsyll, dur, tempo (syll/s), ASD (s/syll)
w10118con_mono, w10118con, 8, 1, , 832, 341.203, 2.44, 0.410
w10118con_mono, w10118con, 8, 2, r_0118_c_a_ipu_bs_bp_1, 0, 1.672, 0, 0
```
