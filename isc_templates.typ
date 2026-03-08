// Template for ISC bachelor degree programme at the School of engineering in Sion
// Since 2024, @pmudry with contributions from @LordBaryhobal, @MadeInShineA
// Bachelor thesis template first page inspired from Lasse Rosenow work on https://typst.app/universe/package/haw-hamburg-master-thesis

#import "lib/includes.typ" as inc
#import "@preview/gentle-clues:1.3.0": clue

// Global settings
#let space-after-heading = 0.8em
#let chapter-font-size = 1.5em
#let chapter-font-weight = 700
#let global-keywords = inc.global-keywords
#let version = "0.7.0"

//////////////////////////
// User callable functions
// //////////////////////////
#let heavy-title(title, mult: 1.5, bottom: 2pt, top: 4em) = {
  set text(size: chapter-font-size * mult, weight: chapter-font-weight)
  block(fill: none, inset: (x: 0pt, bottom: bottom, top: top), below: space-after-heading * mult, {
    title
  })
}

// Draw a decorative rule under a chapter heading.
// The decoration pattern cycles with each numbered chapter.
//
// decorations — array of patterns, one entry consumed per chapter (cycling).
//   Each pattern is an array of shape dicts: (shape:, filled:)
//     shape:  "square" | "circle" | "diamond"
//     filled: true  → shape filled with hei-purple
//             false → white interior, hei-purple border
//   Multiple dicts in one pattern draw multiple shapes, left-to-right, at the right end.
// enabled — set to false to draw only the plain line with no shape ornaments.
#let chapter-rule(
  decorations: (
    ((shape: "square",  filled: false),),
    ((shape: "circle",  filled: true),),
    ((shape: "square",  filled: true),),
    ((shape: "diamond", filled: false),),
    ((shape: "circle",  filled: true),),
    ((shape: "diamond", filled: false), (shape: "square", filled: true)),
  ),
  enabled: true,
  chapter: 1,
) = {
  let color = inc.hei-purple
  let sz    = 10pt
  let gap   = 3pt
  let thick = 1pt

  v(-0.4em)

  layout(size => {
      // Horizontal rule
      place(line(length: size.width, stroke: (thickness: thick, paint: black)))

      if enabled and decorations.len() > 0 {
        let pattern = decorations.at(calc.rem(chapter - 1, decorations.len()))
        let n = pattern.len()

        // pattern is ordered left-to-right; last entry is rightmost
        for (i, spec) in pattern.enumerate() {
          let fill-color = if spec.filled { color } else { white }
          let x = size.width - sz - (sz + gap) * (n - 1 - i)

          if spec.shape == "square" {
            place(dx: x, dy: -sz / 2,
              rect(width: sz, height: sz, fill: fill-color, stroke: color))
          } else if spec.shape == "circle" {
            place(dx: x, dy: -sz / 2,
              ellipse(width: sz, height: sz, fill: fill-color, stroke: color))
          } else if spec.shape == "diamond" {
            place(dx: x, dy: -sz / 2,
              polygon(
                fill: fill-color, stroke: color,
                (sz / 2, 0pt),
                (sz,     sz / 2),
                (sz / 2, sz),
                (0pt,    sz / 2),
              ))
          }
        }
      }

      v(1em)
    })
}

// Enable the display of headers and footers
#let set-header-footer(enabled) = {
  context inc.header-footers-enabled.update(enabled)
}

// Make a page break so that the next page starts on an odd page
#let cleardoublepage() = {  
  pagebreak(weak: true)    
  inc.blank-page.update(true)
  pagebreak(to: "odd", weak: true)  
  inc.blank-page.update(false)
}

// Indicate that something still needs to be done
#let todo(body, fill-color: yellow.lighten(50%)) = {
  set text(black)
  box(baseline: 25%, fill: fill-color, inset: 4pt, [*TODO* #body])
}

// Generate a lorem ipsum with paragraphs
#let lorem-pars(n-words, each: 5) = {
  let n = int(n-words / (each * 30))  
  let sentences = lorem(n * (each * 30)).split(". ")

  range(n)
    .map(i => sentences.slice(i * each, count: each).join(". ") + [.])
    .join(parbreak())
}

// Cetz
#let scale-to-width(width, body) = layout(page-size => {
  let size = measure(body, ..page-size)
  let target-width = if type(width) == ratio {
    page-size.width * width
  } else if type(width) == relative {
    page-size.width * width.ratio + width.length
  } else {
    width
  }
  let multiplier = target-width.to-absolute() / size.width
  scale(reflow: true, multiplier * 100%, body)
})

//
// Multiple languages support
// Thanks @LordBaryhobal for the original idea
//
#let langs = json("i18n.json")

#let i18n(lang, key, extra-i18n: none) = {
  let langs = langs
  if type(extra-i18n) == dictionary {
    for (lng, keys) in extra-i18n {
      if not lng in langs {
        langs.insert(lng, (:))
      }
      langs.at(lng) += keys
    }
  }

  let keys = langs.at(lang)

  assert(key in keys, message: "I18n key " + str(key) + " doesn't exist")
  return keys.at(key)
}

#let _make-outline(font: auto, title, ..args) = {
  {
    show heading:none
    heading(bookmarked: true, numbering: none, outlined: false)[Table of contents]    
  }

  let title = if font == auto { title } else {
    text(font: font, title)
  }
  
  outline(title: {
    v(2em)
    text(size: chapter-font-size, weight: chapter-font-weight, title)
    v(3em)
  }, indent: 2em, ..args)
  pagebreak(weak: true)
}

// Generates the special appendix page
#let appendix-page() = {
  context{
    {
      show heading: none
      heading(numbering:none)[#i18n(inc.global-language.get(), "appendix-title")]      
    }

    // The appendix page
    place(center + horizon, [
      #{
        set text(size: chapter-font-size * 2, weight: chapter-font-weight)
        i18n(inc.global-language.get(), "appendix-title")
      }
    ])
  }
}

// Generate the table of contents with a given depth
#let table-of-contents(depth: 2) = {
  context {
    if inc.show-toc-enabled.get() {
      let f = inc.global-language.get()
      _make-outline(i18n(f, "toc-title"), depth: depth)
    }
  }
}

// Generate the table of figures
#let table-of-figures(depth: 1) = {
  context {
    let f = inc.global-language.get()
    outline(
      title: heavy-title(i18n(f, "figure-table-title"), mult: 1, top: 1em, bottom: 1em),
      depth: 1,
      indent: auto,
      target: figure.where(kind: image),
    )
  }
}

// Generate the proper header for the code samples appendix
#let code-samples() = {  
  context{
    heading(
      numbering: none,
      depth: 2,
      outlined: false,
      bookmarked: false,
      text(
        heavy-title(i18n(inc.global-language.get(), "appendix-code-name"), mult: 1, top: 1em, bottom: 1em)),
    )
  }  
}

#let the-bibliography(
  bib-file: none,
  full: false,
  style: "ieee"  
) = {
  context {        
    let title = i18n(inc.global-language.get(), "bibliography-title")    
    show heading: none
    heading(bookmarked: true, numbering: none, outlined: true)[#title]
    heavy-title(title, mult: 1, top: 0.5em, bottom: 0.3em)    
    bibliography("src/" + bib-file, full: full, style: style, title:none)
  }
}


#let abstract-footer(lang) = {
  // Suppress the inline-code background box so URLs render as plain monospace
  show raw.where(block: false): it => it

  context {
    let repo       = str(inc.global-project-repos.get())
    let kw-list    = inc.global-keywords.get().join(", ")
    let repo-title = i18n(lang, "repository")
    let kw-title   = i18n(lang, "keywords")
    let accent-repo = rgb(30, 102, 245)   // blue
    let accent-kw   = rgb(23, 146, 153)   // teal

    // Repo box: floated to the top-right, compact insets, normal text size
    // Measure header and body to size the box snugly around its content
    let repo-header-w = measure(box(inset: (x: 0.3em),
      grid(columns: (auto, auto), gutter: 1em,
        align: (horizon, left + horizon),
        box(height: 0.8em)[#text(0.8em)[🔗]], text(0.8em, repo-title))
    )).width
    let repo-body-w = measure(box(inset: (x: 0.4em), raw(repo))).width
    let repo-box-w  = calc.max(repo-header-w, repo-body-w) + 2pt  // 2pt for left stroke

    place(top + right,
      clue(
        align(right, link(repo)[#raw(repo)]),
        title: text(0.8em, repo-title), icon: text(0.8em)[🔗],
        accent-color: accent-repo, body-color: accent-repo.lighten(95%),
        radius: 0pt, stroke-width: 2pt,
        header-inset: 0.3em, content-inset: 0.4em,
        width: repo-box-w,
      )
    )

    // Push keywords to the bottom of the page
    v(1fr)

    // Full-width keywords clue
    clue(
      align(center, text(0.9em,kw-list)),
      title: text(0.9em,kw-title), icon: text(0.9em)[🏷],
      accent-color: accent-kw, body-color: accent-kw.lighten(95%),
      header-inset: 0.3em, content-inset: 0.7em,
      radius: 0pt, stroke-width: 3pt,
    )
  }
}

//////////////////////////
// Source code inclusion
//////////////////////////
#let _luma-background = luma(250)

// Replace the original function by ours
#let codelst-sourcecode = inc.sourcecode

#let code = codelst-sourcecode.with(
  frame: block.with(fill: _luma-background, stroke: 0.5pt + luma(80%), radius: 3pt, inset: (x: 6pt, y: 7pt)),
  numbering: "1",
  numbers-style: (lno) => text(luma(210), size: 7pt, lno),
  numbers-step: 1,
  numbers-width: -1em,
  gutter: 1.2em,
)

/*********************************
 ** The template itself
 ********************************/
#let project(
  title: [Report title],
  subtitle: none,
  academic-year: [2025-2026],
  
  // Document type: "report", "thesis", "document", "exec-summary"
  doc-type: "report",  
  split-chapters: true,

  // Document specific
  show-cover: true,
  show-toc: 2, // false = no TOC, true = TOC with depth 2, integer = TOC with given depth
  fancy-line: true, // Use decorative line with squares (false = simple line)

  // Bachelor thesis specific
  thesis-supervisor: [Thesis supervisor],
  thesis-co-supervisor: none,
  thesis-expert: "[Thesis expert]",
  thesis-id: none,
  project-repos: none,
  keywords: (),
  major: (),
  school: [School name],
  programme: [Informatique et Systèmes de Communication],
  
  // Executive summary specific
  summary: none,
  content: none,
  student-picture: none,
  permanent-email: "john@doe.com",
  video-url: none,
  bind: none,
  footer: none,
  
  // Course report specific
  course-name: none,
  course-supervisor: none,
  semester: none,
  cover-image: none,
  cover-image-height: 10cm,
  cover-image-caption: [KNN graph -- Inspired by _Marcus Volg_],
  cover-image-kind: auto,
  cover-image-supplement: auto,
  
  
  // A list of authors, separated by commas
  authors: (),
  date: none,
  logo: auto, // auto = default logo for document type, none = no logo
  equations: false,
  revision: none, // Like a version number
  language: "fr",
  extra-i18n: none,
  code-theme: "bluloco-light",
  body,
) = {
  
  // Validate doc-type
  let valid-doc-types = ("report", "thesis", "document", "exec-summary")
  assert(doc-type in valid-doc-types, message: "Invalid doc-type '" + doc-type + "'. Must be one of: " + valid-doc-types.join(", "))
  
  // Update state with the passed values so they are accessible globally
  inc.global-keywords.update(keywords)
  inc.global-language.update(language)

  // Normalize show-toc: true -> 2, false -> 0, int -> int
  let toc-depth = if show-toc == false { 0 } else if show-toc == true { 2 } else { int(show-toc) }
  inc.show-toc-enabled.update(toc-depth > 0)

  if(project-repos != none) {
    inc.global-project-repos.update(project-repos)
  }else{
    if(doc-type == "thesis") {panic("No project repository provided, you need to provide one!")}
  }

  let i18n = i18n.with(extra-i18n: extra-i18n, language)

  // Set the document's basic properties.
  set document(author: authors, title: title, date: date, keywords: keywords, description: "Using ISC template ver. " + version)

  set par(justify: true)
  
  //  Fonts
  let body-font = ("Source Sans Pro", "Source Sans 3", "Libertinus Serif")
  let sans-font = ("Source Sans Pro", "Source Sans 3", "Inria Sans")
  let raw-font = "Fira Code"
  let math-font = ("Asana Math", "Fira Math")

  // Default body font
  set text(font: body-font, lang: language)

  // Set other fonts
  // show math.equation: set text(font: math-font) // For math equations
  let selected-theme = "src/themes/" + code-theme + ".tmTheme"
  set raw(theme: selected-theme)
  show raw: set text(font: raw-font) // For code

  show heading: set text(font: sans-font) // For sections, sub-sections etc..
  show heading: set block(below: space-after-heading)

  /////////////////////////////////////////////////
  // Citation style
  /////////////////////////////////////////////////
  set cite(style: auto, form: "normal")

  /////////////////////////////////////////////////
  //  Basic pagination and typesetting
  /////////////////////////////////////////////////
  set rect(width: 100%, height: 100%, inset: 4pt)

  // Thesis specific settings
  set page(
    margin: (inside: 2.5cm, outside: 1.5cm, bottom: 2.1cm, top: 2cm), // Binding inside
    paper: "a4",
  ) if(doc-type == "thesis")  

  // Report specific settings
  set page(
    margin: (inside: 2.5cm, outside: 2cm, y: 2.1cm), // Binding inside
    paper: "a4",    
  ) if(doc-type == "report")

  // Document specific settings — symmetric margins
  set page(
    margin: (x: 2.0cm, y: 1.8cm),
    paper: "a4",    
  ) if(doc-type == "document")

  if (doc-type != "thesis") {
    // For reports and documents, we want to put the header and footer on all pages
    set-header-footer(true)
  } else {
    // For theses, we want to put the header and footer only on the first page
    set-header-footer(false)
  }

  show heading: it => {
    // In a thesis, put chapters begin on odd pages
    // Add the header in a block to make space around it
    if it.level == 1 and doc-type == "thesis" and split-chapters {      
      pagebreak(weak: true)    
      inc.blank-page.update(true)
      pagebreak(to: "odd", weak: true)  
      inc.blank-page.update(false)
      
      block(fill: none, inset: (x: 0pt, bottom: space-after-heading, top: 4em), below: 0pt, {
        // If the heading has a numbering, display it
        if (it.numbering != none) {
          text(i18n("chapter-title") + " " + counter(heading).display() + " " + it.body, size: chapter-font-size, weight: chapter-font-weight)        
        } else {
          it
        }
        // Decorative rule — only for numbered (chapter) headings
        if it.numbering != none {
          context chapter-rule(chapter: counter(heading).get().first())
        }

      })
    } else {
      it
    }
  }

  // Manage authors single and plural
  let authors-str = ()

  if type(authors) == str {
    authors = (authors,)
  }

  if authors.len() > 1 {
    authors-str = authors.join(", ")
  } else if authors.len() == 1 {
    authors-str = authors.at(0)
  } else {
    panic("No authors provided for the report")
  }  

  let footer-title = if type(title) == str { title.replace("\n", " – ") } else { title }

  let footer-content = context text(0.75em)[
    #{
      emph(footer-title) 
      if revision != none {
          text(", rev " + revision, style: "italic")
      }

      h(1fr)
      counter(page).display("1/1", both: true)
    }
  ]

  set page(
    // For pages other than the first one
    header: context if counter(page).get().first() > 1 {
      if inc.header-footers-enabled.get() and not inc.blank-page.get() {
        let header-content = text(0.75em)[
          #emph(authors-str)            
        ]

        let page = counter(page).get().first()
        let content = if calc.odd(page) { align(right, header-content) } else { align(left, header-content)}
        content
      }
    },
    header-ascent: 40%,
    footer: context {
      if counter(page).get().first() == 1 and not show-cover and (doc-type == "report" or doc-type == "document") {
        // First page compact mode: show date and version
        text(0.75em, {
          if date != none {
            inc.custom-date-format(date, i18n("date-format"), language)
          }
          if revision != none {
            if date != none {
              [ — v#revision]
            } else {
              [v#revision]
            }
          }
          h(1fr)
          counter(page).display("1/1", both: true)
        })
      } else if counter(page).get().first() > 1 {
        if inc.header-footers-enabled.get() and not inc.blank-page.get() {
          move(dy: 5pt, line(length: 100%, stroke: 0.5pt))
          footer-content
        } else {
          none
        }
      }
    },
  )

  // Links coloring
  show link: set text(ligatures: true, fill: blue)

  // Sections numbers
  set heading(numbering: "1.1.1 –")

  /////////////////////////////////////////////////
  // Handle specific captions styling
  /////////////////////////////////////////////////

  // Compute a supplement for captions as they are not to my liking
  let getSupplement(it) = {
    let f = it.func()
    if (f == image) {
      i18n("figure-name")
    } else if (f == table) {
      i18n("table-name")
    } else if (f == raw) {
      i18n("listing-name")
    } else {
      auto
    }
  }

  set figure(numbering: "1", supplement: getSupplement)

  // Make the caption like I like them
  show figure.caption: set text(9pt) // Smaller font size
  show figure.caption: emph // Use italics
  set figure.caption(separator: " - ") // With a nice separator

  show figure.caption: it => { it.counter.display() } // Used for debugging

  // Make the caption like I like them
  show figure.caption: it => context {
    if it.numbering == none {
      it.body
    } else {
      it.supplement + " " + it.counter.display() + it.separator + it.body
    }
  }

  /////////////////////////////////////////////////
  // Code related, only for inline as the
  // code block is handled by function at the top of the file
  /////////////////////////////////////////////////

  // Inline code display,
  // In a small box that retains the correct baseline.
  show raw.where(block: false): box.with(fill: _luma-background, inset: (x: 2pt, y: 0pt), outset: (y: 2pt), radius: 1pt)

  // Allow page breaks for raw figures
  show figure.where(kind: raw): set block(breakable: true)

  /////////////////////////////////////////////////
  // Cover pages
  /////////////////////////////////////////////////
  // Default logo for document type
  let logo = if logo == auto and doc-type == "document" {
    if show-cover{
      image("lib/assets/isc_logo.svg")      
    } else {
      image("lib/assets/isc_logo_raw.svg")
    }
  } else if logo == auto {
    none
  } else {
    logo
  }

  if not show-cover and (doc-type == "report" or doc-type == "document") {
    // Compact inline header: logo, title, authors — no page break
    if logo != none {
      place(
        top + right,
        dx: 0mm,
        dy: -2mm,
        clearance: 0em,
        box(width: 2.2cm, logo),
      )
    }

    text(font: sans-font, 1.8em, weight: 700, title)
    linebreak()    
    v(-0.2em)
    text(1.1em, authors.join(", "))
    v(-0.1em)

    // A line to separate the header from the content
    if fancy-line {
      layout(size => {
        let total-w = size.width
        let solid-end = 0.8 * total-w
        let square-size = 1.5pt
        let color = luma(20)
        // Solid line for the first 80%
        place(line(length: solid-end, stroke: (paint: color, thickness: 1.5pt)))
        // Small squares with increasing spacing for the remaining 40%
        let remaining = total-w - solid-end
        let x = solid-end + 0.5pt
        let gap = 0.5pt
        let positions = ()
        while x < total-w {
          positions.push(x)
          gap = gap * 1.3
          x = x + square-size + gap
        }
        for px in positions {
          place(dx: px, dy: -square-size / 2, rect(width: square-size, height: square-size, fill: color, stroke: none))
        }
        v(square-size)
      })
    } else {
      line(length: 100%, stroke: (paint: luma(20), thickness: 1.5pt))
    }
    v(0.4em)
  } else if (doc-type == "report") {
    import "lib/pages/cover_report.typ": cover_page

    let report_cover = cover_page(
      course-supervisor: course-supervisor,
      course-name: course-name,
      font: sans-font,
      title: title,
      subtitle: subtitle,
      semester: semester,
      academic-year: academic-year,
      cover-image: cover-image,
      cover-image-height: cover-image-height,
      cover-image-caption: cover-image-caption,
      cover-image-kind: cover-image-kind,
      cover-image-supplement: cover-image-supplement,
      authors: authors,
      date: date,
      logo: logo,
      language: language,
    )

    report_cover
  } else if doc-type == "document" {
    import "lib/pages/cover_document.typ": cover_page

    let document_cover = cover_page(
      font: sans-font,
      title: title,
      subtitle: subtitle,
      authors: authors,
      date: date,
      revision: revision,
      logo: logo,
      language: language,
    )

    document_cover
  } else if doc-type == "thesis" {
    import "lib/pages/cover_bachelor.typ": cover_page

    let supervisors = ()

    if (thesis-co-supervisor == none) {
      supervisors = (thesis-supervisor,)
    } else {
      supervisors = (thesis-supervisor, thesis-co-supervisor)
    }

    let thesis_cover = cover_page(
      supervisors: supervisors,
      expert: thesis-expert,
      font: sans-font,
      title: title,
      subtitle: subtitle,
      semester: semester,
      academic-year: academic-year,
      school: school,
      programme: programme,
      major: major,      
      authors: authors-str,
      thesis-id: thesis-id,
      submission-date: date,
      revision: revision,
      logo: logo,
      language: language,
    )

    thesis_cover
  } else if doc-type == "exec-summary" {
    import "lib/pages/cover_exec_summary.typ": cover_page

    let supervisors = ()

    if (thesis-co-supervisor == none) {
      supervisors = (thesis-supervisor,)
    } else {
      supervisors = (thesis-supervisor, thesis-co-supervisor)
    }

    let exec_summary = cover_page(
      title: title,
      authors: authors-str,
      summary: summary,
      content: content,
      picture: student-picture,
      permanent-email: permanent-email,
      video-url: video-url,
      academic-year: academic-year,
      supervisors: supervisors,
      expert: thesis-expert,
      school: school,
      programme: programme,
      major: major,
      language: language,      
      bind: bind,
      footer: footer,
      font: sans-font,
    )

    exec_summary
  }

  // Add some top spacing on the first content page for report and document
  if show-cover and (doc-type == "report" or doc-type == "document") {
    v(2em)
  }

  // Auto-insert table of contents if enabled
  if toc-depth > 0 {
    table-of-contents(depth: toc-depth)
  }

  body
}