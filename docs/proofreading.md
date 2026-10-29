# Proofreading

How a prayer-book text, a psalm, or a verse of Scripture gets onto the site (BUILD.md P3.11,
AGENTS.md §6). Every text is received, not reconstructed: it is transcribed from the page images
of an identified printing and proofread twice against them. Nothing is typed from memory, copied
from another book or edition, or "corrected" toward a familiar form, even as a placeholder.

## 1. Before transcribing

1. **Identify the printing.** Its entry in [content/SOURCES.md](../content/SOURCES.md) names the
   printer, place, year, and impression, where the page images came from (URL or scan), and its
   rights per territory, read from the title page, the copyright page, and any renewal record.
   Candidate files are downloaded into the gitignored `research/` folder (D21), never into the
   app. The entry stays `pending` until the proofreading below is done and recorded.
2. **Keep the page images at hand** for every page transcribed: the scan's file name or URL and
   its page number are what each pass is checked against.
3. **Use the content format** ([docs/content-format.md](content-format.md)): the book, printing,
   and page in the front matter; `@page` and `{page|…}` wherever the printed page turns; the
   printing's italics, small capitals, ¶, ℣, and ℟ as printed.

## 2. Two independent passes

- **Pass one** is the transcription itself, written straight into `content/…` from the page
  images, a page at a time.
- **Pass two** is made independently: a second transcription of the same pages from the same
  images, without looking at pass one, saved in the gitignored `research/proofreading/<document
  id>/pass2.txt`. It may be made by a person or by an agent; it must not be made by copying,
  correcting, or reformatting pass one, or from another edition's text. Where text recognition
  (OCR) helps, its output counts as raw material for a pass, never as a pass by itself, and is
  read against the image word by word.
- Each pass records who made it (an agent or a named person, never "the owner" unless the owner
  did it) and the date.

Texts from another site or edition, such as The Daily Office 2019's copies of public-domain books
or a web transcription, are never a pass. They may be consulted afterwards to look for places
worth a third look, and that consultation is recorded (§4).

## 3. Comparing them, word by word

Compare the two passes with Git's word-level diff, which needs no other tool:

```bash
git diff --no-index --word-diff=plain --word-diff-regex='[^[:space:]]+' content/books/bcp1662/morning-prayer.txt research/proofreading/bcp1662.morning-prayer/pass2.txt
```

Every difference, however small (a comma, a capital, *shew* against *show*, a hyphen, an italic
mark), is settled against the page image, never by preference:

1. Look at the image at the highest resolution available.
2. Write what the printing has, in the content file.
3. If the image cannot settle it (a broken letter, a blot, a gutter), check a second scan of the
   same printing; if there is none, record the doubt in the proofreading record and leave the
   reading the clearer image supports.
4. Run the diff again until it shows no differences other than the settled ones, each listed in
   the record.

A printing's own errors are kept as printed and recorded as errata (§5); they are never silently
fixed.

## 4. The record in SOURCES.md

When a document is proofread, its printing's entry in `content/SOURCES.md` gets a line in its
prose, and its `checked:` key is brought up to date:

```
- **Proofread:** bcp1662.morning-prayer, pp. 3–20: pass one (agent, 2026-11-02), pass two
  (agent, 2026-11-03), 14 differences settled against the images (3 commas, 2 capitals, 1 italic,
  8 word divisions in the scan's OCR), no doubts left; The Daily Office 2019 not consulted.
```

Only when every document a printing supplies has such a line, and its rights are recorded, does
its `status` become `cleared`, for the territories the evidence supports (D14). The content
compiler refuses any text whose source is not.

## 5. Errata: the printing's errors and readers' reports

- **A printing's own error** (a misprint, a wrong verse number) is kept as printed. Its entry
  records it under **Errata**: the page, what is printed, what is evidently meant, and the
  evidence (another impression of the same printing, the book's own text elsewhere). Showing a
  note beside the text is a later choice (P27.5); changing the text never is.
- **A reader's report** comes to support@prayerbookatlas.com (the support page asks for the book,
  the page, and what is wrong, P20.2). It is checked against the page image, never against
  memory or another edition. If our transcription is wrong, the content file is fixed, the
  correction is listed in the entry's record with the date and "reader's report", and the next
  deploy carries it; if the printing itself has it, it is recorded as an erratum as above. The
  reader's name and address are not recorded in the repository.
- Every autumn, the errata and corrections are reviewed with the annual verification (P27.2,
  P27.5).
