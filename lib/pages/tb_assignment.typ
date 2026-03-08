// Rendering logic for the TB assignment sheet and its addendum.
// Called from src/tb_assignment.typ via the exported tb-assignment-page() function.

// Inline page-title to avoid cyclic import with isc_templates.typ
#let _page-title(title) = {
  set text(size: 1.5em * 1.5, weight: 700)
  block(fill: none, inset: (x: 0pt, bottom: 2pt, top: 4em), below: 0.8em * 1.5, title)
}

#let tb-assignment-page(
  // Identity
  student:       "Prénom Nom",
  id:            "ISC-ID-xx-x",
  supervisor:    "Prof. Dr ...",
  expert:        "Dr ...",
  filiere:       "ISC",
  academic-year: "20xx-xx",

  // Mandant — "hes" | "industrie" | "etablissement"
  mandant: "hes",

  // Lieu — "hes" | "industrie" | "etablissement"
  lieu: "hes",

  // Confidentiality
  confidential: false,

  // Content
  title:       [Titre du travail de bachelor],
  description: [Description du travail de bachelor.],
  objectifs:   [Objectifs du travail de bachelor.],

  // Dates
  date-attribution:  [xx.xx.xxxx],
  date-debut:        [xx.xx.xxxx],
  date-remise:       [xx.xx.xxxx, 12:00],
  date-defense:      [Semaines xx et xx],
  date-expo-hei:     [xx.xx.xxxx -- HEI],
  date-expo-monthey: [xx.xx.xxxx -- Monthey],

  // Addendum
  project-type:         "exploratoire",
  data-dep:             1,
  data-explanation:     none,
  material-dep:         1,
  material-explanation: none,
  extra-info:           none,
) = {

  // ── Style constants ────────────────────────────────────────────────────
  let _fill   = luma(235)
  let _ci     = (x: 6pt, y: 5pt)
  let _purple = rgb("#E20571")
  let _stroke = 0.5pt + luma(160)

  let _lbl(body, ..args) = table.cell(
    fill: _fill, inset: _ci,
    text(weight: "bold", size: 9pt, body),
    ..args
  )

  let _val(body, ..args) = table.cell(
    inset: _ci,
    text(size: 9pt, body),
    ..args
  )

  let _checkbox(checked) = box(
    baseline: 18%,
    rect(
      width: 9pt, height: 9pt, radius: 1pt,
      fill: if checked { _purple } else { white },
      stroke: 0.5pt + if checked { _purple } else { luma(140) },
      if checked { place(center + horizon, text(white, size: 7pt)[✓]) }
    )
  )

  let _radio(n, selected) = {
    for i in range(1, n + 1) {
      box(
        baseline: 18%,
        circle(
          radius: 4.5pt,
          fill: if i == selected { _purple } else { white },
          stroke: 0.5pt + if i == selected { _purple } else { luma(140) },
        )
      )
      h(4pt)
      text(size: 9pt, str(i))
      h(12pt)
    }
  }

  // Table 1 — informations générales
  table(
    columns: (1fr, 1fr, 1fr),
    stroke: _stroke,

    _lbl[Filière], _lbl[Année académique], _lbl[No TB],
    _val[#filiere], _val[#academic-year], _val[#id],

    _lbl[Mandant], _lbl[Expert·e (données complètes)], _lbl[Lieu d'exécution],
    table.cell(fill: white, inset: _ci)[
      #set text(size: 9pt)
      #_checkbox(mandant == "hes") HES---SO Valais-Wallis \
      #_checkbox(mandant == "industrie") Industrie \
      #_checkbox(mandant == "etablissement") Établissement partenaire
    ],
    _val[#expert],
    table.cell(fill: white, inset: _ci)[
      #set text(size: 9pt)
      #_checkbox(lieu == "hes") HES---SO Valais-Wallis \
      #_checkbox(lieu == "industrie") Industrie \
      #_checkbox(lieu == "etablissement") Établissement partenaire
    ],

    _lbl[Travail confidentiel], _lbl[Professeur·e], _lbl[Étudiant·e],
    table.cell(fill: white, inset: _ci)[
      #set text(size: 9pt)
      #_checkbox(confidential) oui #h(1em)
      #_checkbox(not confidential) non
    ],
    _val[#supervisor],
    _val[#student],
  )

  v(0.6em)

  // Table 2 — titre, description, objectifs (flexible height)
  block(width: 100%, height: 1fr,
    table(
      columns: (auto, 1fr),
      rows: (auto, 1fr, 1fr),
      stroke: _stroke,
      _lbl[Titre],       _val[#title],
      _lbl[Description], _val[#description],
      _lbl[Objectifs],   _val[#objectifs],
    )
  )

  v(0.6em)

  // Table 3 — signatures + délais
  table(
    columns: (1fr, 1fr, 2fr),
    stroke: _stroke,
    table.cell(colspan: 2, fill: _fill, inset: _ci)[#text(weight: "bold", size: 9pt)[Signature]],
    table.cell(fill: _fill, inset: _ci, align: horizon)[#text(weight: "bold", size: 9pt)[Délais]],

    table.cell(fill: white, inset: _ci, align: top)[
      #set text(size: 8pt)
      Responsable orientation | filière
      #v(2em)
    ],

    table.cell(fill: white, inset: _ci, align: top)[
      #set text(size: 8pt)
      Étudiant·e
      #v(2em)
    ],

    table.cell(fill: white, inset: _ci, align: horizon)[
      #set text(size: 9pt)
      Attribution du thème : #h(1fr) *#date-attribution* \
      Début du travail de bachelor : #h(1fr) *#date-debut* \
      Remise du rapport final : #h(1fr) *#date-remise* \
      Défense orale : #h(1fr) *#date-defense* \
      Expositions et Pitch : #h(1fr) *#date-expo-hei* \
      #h(1fr) *#date-expo-monthey*
    ],
  )

  // ── PAGE 2 : Addendum ─────────────────────────────────────────────────
  pagebreak()

  _page-title("Addendum — Données du travail de bachelor")

  heading(level: 2, numbering: none, outlined: false, bookmarked: false)[Type de projet]

  [#_checkbox(project-type == "exploratoire") Exploratoire #h(2.5em) #_checkbox(project-type == "implementation") Implémentation]

  heading(level: 2, numbering: none, outlined: false, bookmarked: false)[Data dependencies]

  _radio(5, data-dep)

  v(0.3em)
  table(
    columns: (auto, 1fr),
    stroke: none,
    inset: (x: 6pt, y: 3pt),
    text(size: 9pt, weight: "bold")[1], text(size: 9pt)[No data],
    text(size: 9pt, weight: "bold")[2], text(size: 9pt)[Data collected, cleaned and ready to be used],
    text(size: 9pt, weight: "bold")[3], text(size: 9pt)[Data collected, cleaning needed],
    text(size: 9pt, weight: "bold")[4], text(size: 9pt)[Data not collected but available online],
    text(size: 9pt, weight: "bold")[5], text(size: 9pt)[Data not collected and dependent on external actors],
  )

  if data-dep >= 3 {
    v(0.4em)
    if data-explanation != none {
      data-explanation
    } else {
      text(style: "italic", size: 9pt)[_Please include an explanation of the effort needed to collect the data and clean it. For level 5, add a presentation of the backup plan._]
    }
  }

  heading(level: 2, numbering: none, outlined: false, bookmarked: false)[Material dependencies]

  _radio(3, material-dep)

  v(0.3em)
  table(
    columns: (auto, 1fr),
    stroke: none,
    inset: (x: 6pt, y: 3pt),
    text(size: 9pt, weight: "bold")[1], text(size: 9pt)[No specific material needed],
    text(size: 9pt, weight: "bold")[2], text(size: 9pt)[Material is readily accessible on-site],
    text(size: 9pt, weight: "bold")[3], text(size: 9pt)[Material is not readily accessible and needs to be acquired],
  )

  if material-dep >= 2 {
    v(0.4em)
    if material-explanation != none {
      material-explanation
    } else {
      text(style: "italic", size: 9pt)[_Please mention what material/hardware is needed. If level 3, describe the acquiring procedure and the backup plan._]
    }
  }

  heading(level: 2, numbering: none, outlined: false, bookmarked: false)[Extra information]

  if extra-info != none {
    extra-info
  } else {
    text(style: "italic", size: 9pt)[_If you have any more information about the project that you'd like to transmit to the harmonization team._]
  }
}
