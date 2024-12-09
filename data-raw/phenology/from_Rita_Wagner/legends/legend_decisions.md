# Decisions for dealing with legend and data ambiguities
# In general, blanks on typed data sheets are `-` and blanks on handwritten data sheets are NA according to Rita Wagner.
# See 2016-03-12 email to Ian Wayland and same day Lab Notebook entry as well as 2016-03-15 email from Rita Wagner in Lab Notebook 2016-03-25 for additional details. Page numbers refer to the page numbers in the original pdf scans of data sent to me by Rita Wagner.

## Blanks (Equivalent to NA once read into R)

### blk228
- pp. 2, 3 (1997), 5, 6, 11, 12 (1998), and 8,9 (1999) Replace blanks  with `-` according to legend type 4. These blanks were recorded with an `X` and translated to `-` by reformat_pheno. No action needed.
- pp. 30, 31 (2005) for May 30. Remove blanks
- p. 33 (2006) Remove blanks (Original margin notes detail that only certain clones were looked at on June 7.)
- p. 34 (2006) Blanks for one clone on one day only. Remove.
- p. 42 (June 4, 2009) Replace blanks with `-`. 
- p. 44 (2009). Replace blanks with `-`.

### cpf223
- p. 2, 4 (1999) Replace blanks with  `-` according to legend type 4. These blanks were recorded with an `X` and translated to `-` by reformat_pheno. No action needed.
- p. 22 (2005) Remove blanks.
- p. 28 (2007) 1476 FEMALE is blank, but MALE has data. Email from Rita Wagner suggests blank should be `-` here, however all other non-typed boxes are filled out by hand. I think it was just missed and we cannot know what this tree's phenophase was on this date. Remove. 
- p. 42, 43 (2011) Rita Wagner's email suggests that the blanks here should be replaced with `-`. However, many trees on this date and other dates on the page have the `-` already. I believe these blanks should be removed.
- pp. 46 and 47 (2012). I'm going against what Rita Wagner says here and recommending removal of blank entries for all dates here, despite it being typed data. Many of the blanks on May 30 are clearly skipped trees since they have "active" entries on May 28/29 and on May 31. It almost looks like they were just doing spot checks to see when they were getting close to the main event? Given the pattern of "recorded active - blank - recorded active"" that some trees show and the use of `-`s, I think it's safe to assume that blanks from pp. 46 and 47 on all dates on these pages

### wb220
- pp. 2, 4 (1997), pp. 6, 8 (1998) Replace blanks on pp 2,4,6,8 with `-` according to legend type 4. 
- p. 10 (June 23, 1999) Remove blanks.
- pp. 24, 25 (2005) Remove blanks.
- pp. 27, 28 (2006) Remove blanks
- pp. 30 and 31 (2007), replace blanks with `-`. 
- pp. 39 and 40 (2010) Replace blanks with `-`. Not sure about this actually given use of `-` thruout
- pp. 42 and 43 (2011) Remove blanks `-` (Tentatively) looks like they were just peeking at late clones. It's a week after the previous measurement date.
- p. 45 (2012) Remove blank female entries on 11 June. It appears only males were measured, and only for one day. Going against R. Wagner here, but looks like an exception. Actually, no need to remove here because blank female entries were not included in transcription.

