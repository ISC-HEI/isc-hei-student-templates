#import "@preview/isc-hei-tb-assignment:0.7.0" : *

#show: project.with(
  doc-type: "document",
  show-cover: false,
  show-toc: false,
  fancy-line: false,
  language: "fr",
  title: "Données du travail de bachelor",
  authors: "Prénom Nom",     // Nom de l'étudiant·e
  date: datetime.today(),
  revision: "1.0",
)

// ─── Paramètres à renseigner ──────────────────────────────────────────────
#let tb-student       = "Prénom Nom"       // Nom de l'étudiant·e
#let tb-id            = "ISC-ID-26-1"     // Identifiant du TB
#let tb-supervisor    = "Prof. Dr ..."    // Professeur·e responsable
#let tb-expert        = "Dr ..."          // Expert·e
#let tb-filiere       = "ISC"
#let tb-academic-year = "2025-26"

// Mandant : mettre true pour la ligne applicable (une seule à la fois)
#let tb-mandant-hes  = true
#let tb-mandant-ind  = false
#let tb-mandant-etab = false

// Lieu d'exécution : mettre true pour la ligne applicable (une seule à la fois)
#let tb-lieu-hes  = true
#let tb-lieu-ind  = false
#let tb-lieu-etab = false

// Travail confidentiel : true = oui / false = non
#let tb-confidential = false

// Titre, description et objectifs (contenu Typst libre)
#let tb-title       = [Titre du travail de bachelor]
#let tb-description = [Description du travail de bachelor.]
#let tb-objectifs   = [Objectifs du travail de bachelor.]

// Délais (fournies par le responsable de l'orientation)
#let date-attribution  = [xx.xx.xxxx]
#let date-debut        = [xx.xx.xxxx]
#let date-remise       = [xx.xx.xxxx, 12:00]
#let date-defense      = [Semaines xx et xx]
#let date-expo-hei     = [xx.xx.xxxx -- HEI]
#let date-expo-monthey = [xx.xx.xxxx -- Monthey]

// ─── Addendum ─────────────────────────────────────────────────────────────
// Type de projet : "exploratoire" ou "implementation"
#let tb-project-type = "exploratoire"

// Dépendances aux données (1–5) :
//   1 = No data
//   2 = Data collected, cleaned and ready to be used
//   3 = Data collected, cleaning needed
//   4 = Data not collected but available online
//   5 = Data not collected and dependent on external actors
#let tb-data-dep = 1
// Explication obligatoire si tb-data-dep ≥ 3
#let tb-data-explanation = none

// Dépendances matérielles (1–3) :
//   1 = No specific material needed
//   2 = Material is readily accessible on-site
//   3 = Material is not readily accessible and needs to be acquired
#let tb-material-dep = 1
// Explication obligatoire si tb-material-dep ≥ 2
#let tb-material-explanation = none

// Informations complémentaires (none = section vide)
#let tb-extra-info = none

// ─── Fin des paramètres ───────────────────────────────────────────────────

// Internal helpers
#let _fill   = luma(235)
#let _ci     = (x: 6pt, y: 5pt)
#let _purple = rgb("#E20571")

#let _lbl(body, ..args) = table.cell(
  fill: _fill, inset: _ci,
  text(weight: "bold", size: 9pt, body),
  ..args
)

#let _val(body, ..args) = table.cell(
  inset: _ci,
  text(size: 9pt, body),
  ..args
)

#let _checkbox(checked) = box(
  baseline: 18%,
  rect(
    width: 9pt, height: 9pt, radius: 1pt,
    fill: if checked { _purple } else { white },
    stroke: 0.5pt + if checked { _purple } else { luma(140) },
    if checked { place(center + horizon, text(white, size: 7pt)[✓]) }
  )
)

#let _radio(n, selected) = {
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

// ─── PAGE 1 : Fiche d'attribution ─────────────────────────────────────────
#page-title("Données du travail de bachelor")

// Table 1 — informations générales (3 colonnes)
#table(
  columns: (1fr, 1fr, 1fr),

  // Row 1 – labels
  _lbl[Filière], _lbl[Année académique], _lbl[No TB],
  // Row 2 – values
  _val[#tb-filiere], _val[#tb-academic-year], _val[#tb-id],

  // Row 3 – labels
  _lbl[Mandant], _lbl[Étudiant·e], _lbl[Lieu d'exécution],
  // Row 4 – checkboxes + student name
  table.cell(fill: white, inset: _ci)[
    #set text(size: 9pt)
    #_checkbox(tb-mandant-hes) HES---SO Valais-Wallis \
    #_checkbox(tb-mandant-ind) Industrie \
    #_checkbox(tb-mandant-etab) Établissement partenaire
  ],
  _val[#tb-student],
  table.cell(fill: white, inset: _ci)[
    #set text(size: 9pt)
    #_checkbox(tb-lieu-hes) HES---SO Valais-Wallis \
    #_checkbox(tb-lieu-ind) Industrie \
    #_checkbox(tb-lieu-etab) Établissement partenaire
  ],

  // Row 5 – supervisor label
  _lbl[], _lbl[Professeur·e], _lbl[],
  // Row 6 – supervisor name
  _val[], _val[#tb-supervisor], _val[],

  // Row 7 – confidentiality (cols 1-2) + expert label (col 3)
  table.cell(colspan: 2, fill: white, inset: _ci)[
    #set text(size: 9pt)
    *Travail confidentiel* #h(1.5em)
    #_checkbox(tb-confidential) oui #h(1em)
    #_checkbox(not tb-confidential) non
  ],
  _lbl[Expert·e (données complètes)],

  // Row 8 – (empty cols 1–2) + expert name (col 3)
  table.cell(colspan: 2, fill: white, inset: _ci)[],
  _val[#tb-expert],
)

#v(0.6em)

// Table 2 — titre, description, objectifs
#table(
  columns: (auto, 1fr),
  _lbl[Titre],       _val[#tb-title],
  _lbl[Description], _val[#tb-description],
  _lbl[Objectifs],   _val[#tb-objectifs],
)

#v(0.6em)

// Table 3 — espace signatures + délais
#table(
  columns: (1fr, 1fr),
  _lbl[Signature ou visa], _lbl[Délais],

  table.cell(fill: white, inset: (x: 6pt, top: 6pt, bottom: 52pt))[
    #set text(size: 9pt)
    Responsable de l'orientation : \
    #v(1.5em)
    Étudiant·e :
  ],

  table.cell(fill: white, inset: _ci)[
    #set text(size: 9pt)
    Attribution du thème : #h(1fr) *#date-attribution* \
    Début du travail de bachelor : #h(1fr) *#date-debut* \
    Remise du rapport final : #h(1fr) *#date-remise* \
    Défense orale : #h(1fr) *#date-defense* \
    Expositions et Pitch : #h(1fr) *#date-expo-hei* \
    #h(1fr) *#date-expo-monthey*
  ],
)

// ─── PAGE 2 : Addendum ────────────────────────────────────────────────────
#pagebreak()

#page-title("Addendum — Données du travail de bachelor")

// --- Type de projet ---
#heading(level: 2, numbering: none, outlined: false, bookmarked: false)[Type de projet]

#_checkbox(tb-project-type == "exploratoire") Exploratoire #h(2.5em)
#_checkbox(tb-project-type == "implementation") Implémentation

// --- Data dependencies ---
#heading(level: 2, numbering: none, outlined: false, bookmarked: false)[Data dependencies]

#_radio(5, tb-data-dep)

#v(0.3em)
#table(
  columns: (auto, 1fr),
  stroke: none,
  inset: (x: 6pt, y: 3pt),
  text(size: 9pt, weight: "bold")[1], text(size: 9pt)[No data],
  text(size: 9pt, weight: "bold")[2], text(size: 9pt)[Data collected, cleaned and ready to be used],
  text(size: 9pt, weight: "bold")[3], text(size: 9pt)[Data collected, cleaning needed],
  text(size: 9pt, weight: "bold")[4], text(size: 9pt)[Data not collected but available online],
  text(size: 9pt, weight: "bold")[5], text(size: 9pt)[Data not collected and dependent on external actors],
)

#if tb-data-dep >= 3 {
  v(0.4em)
  if tb-data-explanation != none {
    tb-data-explanation
  } else {
    text(style: "italic", size: 9pt)[_Please include an explanation of the effort needed to collect the data and clean it. For level 5, add a presentation of the backup plan._]
  }
}

// --- Material dependencies ---
#heading(level: 2, numbering: none, outlined: false, bookmarked: false)[Material dependencies]

#_radio(3, tb-material-dep)

#v(0.3em)
#table(
  columns: (auto, 1fr),
  stroke: none,
  inset: (x: 6pt, y: 3pt),
  text(size: 9pt, weight: "bold")[1], text(size: 9pt)[No specific material needed],
  text(size: 9pt, weight: "bold")[2], text(size: 9pt)[Material is readily accessible on-site],
  text(size: 9pt, weight: "bold")[3], text(size: 9pt)[Material is not readily accessible and needs to be acquired],
)

#if tb-material-dep >= 2 {
  v(0.4em)
  if tb-material-explanation != none {
    tb-material-explanation
  } else {
    text(style: "italic", size: 9pt)[_Please mention what material/hardware is needed. If level 3, describe the acquiring procedure and the backup plan._]
  }
}

// --- Extra information ---
#heading(level: 2, numbering: none, outlined: false, bookmarked: false)[Extra information]

#if tb-extra-info != none {
  tb-extra-info
} else {
  text(style: "italic", size: 9pt)[_If you have any more information about the project that you'd like to transmit to the harmonization team._]
}
