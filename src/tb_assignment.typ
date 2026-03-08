// ════════════════════════════════════════════════════════════════════════════
// PARAMÈTRES — seule section à modifier
// ════════════════════════════════════════════════════════════════════════════

#let tb-student       = "Barbara Liskov"       // Nom de l'étudiant·e
#let tb-id            = "ISC-ID-26-1"          // Identifiant du TB (depuis la fiche)
#let tb-supervisor    = "Prof. Dr L. Lettry"   // Professeur·e responsable
#let tb-expert        = "Dr John Carmak"       // Expert·e
#let tb-filiere       = "ISC"
#let tb-academic-year = "2025-26"

// Mandant — une seule valeur : "hes" | "industrie" | "etablissement"
#let tb-mandant = "hes"

// Lieu d'exécution — une seule valeur : "hes" | "industrie" | "etablissement"
#let tb-lieu = "hes"

// Travail confidentiel : true = oui / false = non
#let tb-confidential = false

// Titre, description et objectifs (contenu Typst libre)
#let tb-title       = [A hardware-software co-design approach for embedded systems]

#let tb-description = [
In this work, we propose a novel approach for designing embedded systems that integrates hardware and software components. The approach is based on a co-design methodology that allows for the simultaneous development of hardware and software components, leading to improved performance and reduced development time. We evaluate our approach through a case study on the design of an embedded system for a smart home application, demonstrating its effectiveness in terms of performance, energy efficiency, and ease of development.
]

#let tb-objectifs   = [
- Proposer une approche de co-design pour les systèmes embarqués.
- Évaluer l'approche à travers une étude de cas sur un système de maison intelligente.
- Comparer les résultats avec des approches traditionnelles de développement de systèmes embarqués
]

// Délais (fournies par le responsable de l'orientation)
#let date-attribution  = [xx.xx.xxxx]
#let date-debut        = [xx.xx.xxxx]
#let date-remise       = [xx.xx.xxxx, 12:00]
#let date-defense      = [Semaines xx et xx]
#let date-expo-hei     = [xx.xx.xxxx -- HEI]
#let date-expo-monthey = [xx.xx.xxxx -- Monthey]

// ─── Addendum ─────────────────────────────────────────────────────────────

// Type de projet — une seule valeur : "exploratoire" | "implementation"
#let tb-project-type = "exploratoire"

// Dépendances aux données — choisir un entier de 1 à 5 :
//   1 = No data
//   2 = Data collected, cleaned and ready to be used
//   3 = Data collected, cleaning needed
//   4 = Data not collected but available online
//   5 = Data not collected and dependent on external actors
// Explication obligatoire si tb-data-dep ≥ 3
#let tb-data-dep         = 1
#let tb-data-explanation = none

// Dépendances matérielles — choisir un entier de 1 à 3 :
//   1 = No specific material needed
//   2 = Material is readily accessible on-site
//   3 = Material is not readily accessible and needs to be acquired
// Explication obligatoire si tb-material-dep ≥ 2
#let tb-material-dep         = 1
#let tb-material-explanation = none

// Informations complémentaires (none = section vide)
#let tb-extra-info = none

// ════════════════════════════════════════════════════════════════════════════

#import "@preview/isc-hei-tb-assignment:0.7.0" : *

#show: project.with(
  doc-type: "document",
  show-cover: false,
  show-toc: false,
  fancy-line: false,
  language: "fr",
  title: "Donnée du travail de bachelor",
  authors: tb-student,
  date: datetime.today(),
  revision: "1.0",
)

#tb-assignment-page(
  student:       tb-student,
  id:            tb-id,
  supervisor:    tb-supervisor,
  expert:        tb-expert,
  filiere:       tb-filiere,
  academic-year: tb-academic-year,
  mandant:       tb-mandant,
  lieu:          tb-lieu,
  confidential:  tb-confidential,
  title:         tb-title,
  description:   tb-description,
  objectifs:     tb-objectifs,
  date-attribution:  date-attribution,
  date-debut:        date-debut,
  date-remise:       date-remise,
  date-defense:      date-defense,
  date-expo-hei:     date-expo-hei,
  date-expo-monthey: date-expo-monthey,
  project-type:         tb-project-type,
  data-dep:             tb-data-dep,
  data-explanation:     tb-data-explanation,
  material-dep:         tb-material-dep,
  material-explanation: tb-material-explanation,
  extra-info:           tb-extra-info,
)
