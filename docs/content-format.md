# The content format

How texts and facts are written in `content/` (BUILD.md P3.2, Engineering foundation 10). The
compiler, `bin/rails content:compile` (P3.3), reads these files, checks them, and writes the
read-only content database `db/content.sqlite3` (decision 26). Nothing in `content/` is served
until its source is `cleared` in [content/SOURCES.md](../content/SOURCES.md) for the territories
the site serves (`config/content.yml`, D14).

Every text is received, not reconstructed (AGENTS.md §6): it is transcribed from the page images
of an identified printing, proofread twice ([docs/proofreading.md](proofreading.md)), and never
typed from memory, even as a placeholder.

## 1. Layout

```
content/
  SOURCES.md                    the register of sources (its own schema, at its top)
  works.json                    the Atlas's works (P12.1): [{ "id": "...", "title": "..." }]
  books/<book>/...              prayer-book texts, one folder per book id
  scripture/<translation>/...   Bible text, one folder per translation id (P10.2)
  original/...                  the site's own notes, guides, and glossary
  quotations/...                quoted passages of Fathers, Reformers, and divines (P3.6)
  calendar/<book>.json          calendar facts (P4.4)
  lectionary/<id>.json          lectionary facts (P8.5, P9, P11)
  images.json                   images the site serves, beyond the design registry (P3.6)
```

Text files end in `.txt` and are UTF-8 with Unix line ends. Tables end in `.json`. Any other file
in `content/` (except `SOURCES.md` and `README` files) is refused, so nothing is silently ignored.

## 2. Identifiers

- **Books:** the `PrayerBook` ids, which never change: `bcp1662`, `bcp1928us`, `bcp1979us`.
  Books added by permission get new ids (D6).
- **Printings and other sources:** the `id` of their entry in `SOURCES.md`, for example a 1662
  printing as `bcp1662-<printer>-<year>` once identified (P8.1).
- **Translations:** the `Translation` ids: `kjva`, `web`; licensed ones as their license arrives.
- **Documents:** the file's `id:` key, lower case, words joined by hyphens, sections by dots, and
  beginning with the book's id for a prayer-book text: `bcp1662.morning-prayer`,
  `bcp1979us.collects.advent-1`. Unique across the database.
- **Blocks:** `<document id>.<suffix>`. A block's suffix is its `id=` attribute, or, when it has
  none, its position (`1`, `2`, …). Give an explicit suffix to any block something else refers
  to; positions change when a block is added.
- **Works** (P12.1): ids from `content/works.json`, such as `general-confession` or `te-deum`.

## 3. Front matter

A text file begins with `key: value` lines and ends them with a line of three hyphens, `---`.
Values run to the end of the line. Unknown keys are refused.

| Key | Required for | Meaning |
|---|---|---|
| `id` | all | The document's id (§2). |
| `kind` | all | What the document is (§4). |
| `title` | all | Its title, for search results, contents, and sources. As printed for a book's text. |
| `source` | all | The `SOURCES.md` id it comes from: the printing for a book's text, the translation's edition for Scripture, `original` for original work, the quoted book for a quotation. |
| `book` | prayer-book texts | The book's id. |
| `printing` | prayer-book texts | The printing's `SOURCES.md` id: the same as `source`. A text is placed only in the book its printing belongs to (P3.4). |
| `page` | prayer-book texts, quotations | The printed page the document begins on, exactly as printed (`45`, `xii`). |
| `translation` | Scripture | The translation's id; it must match the source's (P3.5). |
| `bible_book` | Scripture | The book of the Bible, as its USFM code (`GEN`, `TOB`, `JHN`). |
| `half_verse_mark` | psalm documents | `colon` (as 1662 and 1928 print) or `asterisk` (as 1979 prints). |
| `work` | optional | The work this document is a witness of (P12.1). |
| `review` | original work | `pending` or `approved` (AGENTS.md §4). Never omitted. |
| `author`, `work_title`, `edition`, `location` | quotations | Who wrote it, in what work, in which edition, and where (book, chapter, page). |

## 4. Kinds of document

| Kind | Body | Examples |
|---|---|---|
| `office`, `prayer`, `collect`, `psalm`, `canticle`, `litany`, `service` | liturgical blocks (§5) | Morning Prayer; a prayer upon several occasions; a collect; Psalm 95; the Te Deum; the Litany; Holy Communion |
| `scripture` | verses (§6) | Genesis 1 in the KJV |
| `note`, `guide`, `glossary` | original paragraphs (§7) | a note on a holy day; a guide for newcomers |
| `quotation` | quoted paragraphs (§7) | a passage of Richard Hooker |

## 5. Liturgical blocks

The body is a sequence of blocks, each beginning with a directive line that starts with `@`,
then its text. Attributes follow the directive as `key=value`, or `key="value with spaces"`.

```
id: bcp1662.example
kind: office
title: An Example
book: bcp1662
printing: bcp1662-example
source: bcp1662-example
page: 3
---
@heading level=1 id=title
THE ORDER FOR {i|EXAMPLE}

@rubric
¶ The Minister shall say,

@versicles id=preces
℣ | First words of the versicle.
℟ | First words of the response.

@page 4

@collect id=collect title="The Collect."
The words of the collect, joined into one paragraph{br}however the source file wraps them.

@amen
Amen.
```

*(The words above are placeholders for the syntax, not a text: real files carry only transcribed
words.)*

| Directive | Block (`LiturgicalBlock`) | Attributes | Text |
|---|---|---|---|
| `@heading` | Heading | `level` (1 for a title) | one paragraph |
| `@paragraph` | Paragraph | | one paragraph |
| `@rubric` | Rubric (an instruction, never words said) | | one paragraph |
| `@amen` | Amen | | one paragraph |
| `@role_lines` | RoleLines | | one line per line: `Role \| words` (the role as printed, a space, a bar, a space), or words alone |
| `@versicles` | Versicles | | the same, with `℣ \|`, `℟ \|`, or the book's own labels |
| `@gloria_patri` | GloriaPatri | `full` (the id of the same book's full text, if any) | what is printed here |
| `@canticle_reference` | CanticleReference | `canticle` (the id of the same book's canticle) | what is printed here |
| `@collect` | Collect | `title` (as printed, if any) | one paragraph |
| `@seasonal_insertion` | SeasonalInsertion | `key` (what goes here: `proper-sentence`, `antiphon`, …) | what is printed here |
| `@psalm` | PsalmVerse, one per line | the psalm's number, as `@psalm 95` (each verse's id is `<document>.p95.<verse>`) | one verse per line: `1 first half : second half`, with the book's mark (§3), and `1 [kjv 2] …` where the KJV numbers it differently |
| `@alternatives` … `@option label="Or this"` … `@end` | Alternatives | each `@option` takes `label` as printed | the blocks of each option, until the next `@option` or `@end` |
| `@page 4` | (no block) | | the following blocks begin on page 4 |

Every block directive except `@page` and `@end` may also take `id=` (§2) and `work=` (§2).

**Paragraphs.** In a one-paragraph block, the lines of the file are joined with single spaces,
so a transcription can wrap anywhere. A line break the printing makes and the reading needs is
written `{br}`. Blank lines inside a block are ignored.

**Inline marks**, within any text:

| Mark | Meaning |
|---|---|
| `{i\|words}` | italic, as printed |
| `{sc\|LORD}` | small capitals, as printed |
| `{name\|N.}`, `{sovereign\|N.}`, `{bishop\|N.}`, `{other\|N.}` | an insertion point: the book prints the mark, and a name may be supplied (P14.3, P8.9) |
| `{br}` | a line break |
| `{page\|5}` | a new printed page begins here; later blocks begin on it too |
| `{{` and `}}` | literal braces |

Square brackets are the printing's own (1979 prints optional words in them), so roles are written
with a bar, never brackets. The printing's own spelling, capitals, punctuation, and errors are kept (errors are recorded as
errata, `docs/proofreading.md`). The ¶ and ℣ ℟ signs are typed as the printing has them.

## 6. Scripture

```
id: kjva.gen.1
kind: scripture
title: Genesis 1
source: kjva-<edition>
translation: kjva
bible_book: GEN
---
1:1 First verse.
1:2 Second verse.
```

One verse per line, `chapter:verse`, a space, the verse as the edition prints it, with the same
inline marks. Only translations `Translation` knows are accepted; a licensed one is accepted only
when its source is `cleared` with a `verse_limit`, and the compiler refuses more verses than the
limit allows (P3.5). Its `notice` is stored with every verse so that it appears wherever the
verse is shown.

## 7. Original work and quotations

The body is paragraphs separated by blank lines; a line beginning `# ` is a heading. Inline marks
as above (`{i|…}` mostly). Scripture is cited by reference, never quoted from memory (D5).

```
id: note.example
kind: note
title: An example note
source: original
review: pending
---
# A heading

A paragraph of original prose.
```

A quotation names its author, work, edition, and location, and its `source` is the edition's
`SOURCES.md` entry, which must be `cleared` (P3.6). Quotations that cannot be traced to an
identified edition are not written at all.

## 8. Tables (JSON)

Calendar and lectionary facts are JSON (D20): names, dates, ranks, and references, never prose.

```json
{
  "id": "bcp1662.calendar",
  "book": "bcp1662",
  "source": "bcp1662-<printing>",
  "entries": [
    { "...": "each entry's fields are defined by the phase that adds the table (P4.4, P8.5)", "page": "xxii" }
  ]
}
```

Every table names its book and source, and every entry its printed `page`. A fact taken from a
cross-check (The Daily Office 2019, another edition) says so in a `checks` list on the entry; a
rule the book does not state is marked `"convention": "<the reason>"`.

`content/works.json` is a list of `{ "id", "title" }`. `content/images.json` is a list of images
with `id`, `path`, `source`, `creator`, `date`, `holder`, `rights_basis`, `status`, and
`depicts_sacred_person`; the compiler also checks `design/image-registry.json` (P3.6).

## 9. What the compiler refuses

Unknown keys and directives; a missing required key; an unknown book, translation, or source; a
source that is not `cleared` for the served territories (a warning instead under
`ALLOW_PENDING=1` in development, never in production or `bin/ci`); a printing placed in another
book; duplicate ids; references that do not resolve (`full=`, `canticle=`, `work=`); a block
with no words or no page; original work without `review`; licensed Scripture beyond its limit;
a quotation without its author, work, edition, and location; an image without its rights record,
or an AI-generated image of a sacred person.
