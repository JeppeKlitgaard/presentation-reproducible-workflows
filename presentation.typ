#import "deps.typ": grayness.image-transparency

// Slides
#import "deps.typ": dutten.slides
#import slides: touying, progress-marker-both, progress-marker-lower, progress-marker-upper
#import touying: *

#import "@preview/unify:0.8.1": add-unit, num, numrange, qty, qtyrange, unit
#import "@preview/zero:0.7.0": num as znum, quan
#import "@preview/suboutline:0.3.0": suboutline
#import "qim.typ"

#let title = "Modern Tools for Reproducible Workflows in Python"
#set document(
  date: datetime(year: 2026, month: 10, day: 28),
  author: "Jeppe Klitgaard",
  title: title,
)

#let footers = (
  utils.display-info-date,
  self => self.info.title,
  context [#utils.slide-counter.display() / #utils.last-slide-number],
)
#show: slides.theme.with(
  title: title,
  subtitle: [Data Pipeline],
  author: context document.author,
  date: context document.date.display(),
  institution: [Center for Quantification of Imaging Data from MAX IV],
  footers: footers,
  footer-style: "thick",
  color: qim.red,
  background-color: qim.background,
  logo: image-transparency(read(qim.logo, encoding: none), width: 2.5cm, alpha: 50%),
  config-common(show-bibliography-as-footnote: true),
)

#set text(size: 20pt)
#show figure.caption: set text(size: 16pt)
#show raw: it => highlight(it, extent: 2pt, fill: gray.transparentize(70%), radius: 3pt)
#show link: set text(fill: navy.lighten(20%))
#show link: it => {
  if it.body == it.dest {
    set text(fill: navy.lighten(20%))
  }
  it
}
#show link: underline.with(offset: 1.5pt)
#show footnote.entry: set text(size: 10pt)
#set footnote.entry(gap: 4pt, clearance: 2pt)
// Footnote entry numbers as plain "[1]" rather than superscript
#show footnote.entry: it => {
  show super: s => s.body + h(0.3em)
  it
}

#let skip = body => {
  set text(fill: black.transparentize(50%))
  body
}

=

#align(center)[
  #set text(size: 36pt, weight: "bold")
  #title

  #set text(size: 24pt, weight: "regular")
  Meeting #context document.date.display()
  #v(5cm)
  Jeppe Klitgaard\
  #[
    #set text(size: 0.7em)
    #link("mailto:s250250@dtu.dk")
  ]
]

// #show: magic.bibliography-as-footnote.with(bibliography("references.bib", title: none))
== Outline <outline>
- A fly-by of modern tools that promote reproducibility
  - Why we need them



== Problem: Reproducibility

#cols[
- No science without reproducibility
- Nature Survey 2016 @baker1500ScientistsLift2016:
  - 52% ($N=1576$): _significant reproducibility crisis_
  - 70% have failed reproduce other scientist's experiments
  - 50% have failed to reproduce their own experiments

- Computations and analyses are easy to reproduce, _right?_
][
#figure(
  image("nature-survey.svg"),
  numbering: none,
  caption: none,
)
]

== Reproducible Environments in Python
- Have you failed to run code due to irreproducible environment?
  - A colleagues code?
  - A paper's code?
  - Your own code?




== Demo `ome_zarr` CLI
+ Install #link("https://docs.astral.sh/uv/getting-started/installation/", `uv`):
  - #skip[
      #set text(size: 12pt)
      _Some Python people may already have it installed_
      - _≈ 30% market share in October 2025: caveats apply, see #link("https://wagtail.org/blog/uv-overtakes-pip-in-ci/", "source")._
      - _90.4K stars on GitHub (2026-10-05)_
    ]
  - Windows: `winget install --id=astral-sh.uv  -e`
  - Linux/MacOS: `curl -LsSf https://astral.sh/uv/install.sh | sh`
+ Install `ome-zarr-py` CLI:
  - `uv tool install --with imagecodecs-zarr git+https://github.com/JeppeKlitgaard/ome-zarr-py@feat-cli-convert`
+ Stream OME-Zarr and convert to TIFF stack (here we pick second level):
  - `ome_zarr export --format tiff-stack --level 2 --overwrite LINK_OR_LOC_OF_OME_ZARR output_tiffs`
  - #skip[
      Example:
      - #[
          #set text(size: 10pt)
          `ome_zarr export --format tiff-stack --level 2 --overwrite "https://s3.g.s4.mega.io/aidjqnzhivz2k6kyxukiymjgfb4wxowhengdp/naturarv3d/CIL_basic_binned_2x2/NaturArv3D_format_viability_study/OME-Zarr/Canislupus_CZM_712__jpegxl_l_0_5__scales_2_4_8_16.ome.zarr" output_tiffs`]
    ]
+ _Optional: Open in Napari (`uvx --with pyqt6 napari output_tiffs`)_

#pagebreak(weak: true)
#align(center + horizon, strong[
  #set text(size: 60pt, fill: black)
  Tool Demo
])

== Notes on tool
- Nice:
  - Streams in compressed format, so network friendly
  - Streams, so memory friendly
  - Emits standard TIFF stack
  - Preserves voxel size metadata

- Just a prototype
  - Intended to prove feasibility
  - Could just as well be a little graphical interface, or both


== Summary
- Initially thought mostly about codecs
- Container format turned out to be more important
- May need to revisit codec when we get closer to implementation stage
- Don't have to make decision now?

== Closing Remarks
- _Everything (?)_ available on private GitHub repo under `qim-center` org
  - #link("https://github.com/qim-center/consult-xct-compression")
    - QIM + Close friends already have access
    - Others can ask for inclusion
  - Slides and source code for every meeting presentation
  - Source code and outputs for all experiments and demos
    - Note: Obviously no volumetric data included
  - Poster including source code
  - Unfinished report that has been abandoned

// #bibliography("references.bib")
#place(hide(bibliography("references.bib")))

- Own experience Cambridge notebooks in Physics
- Own track record of reproducibility
- Tale of two eco-systems
- Uv vs pip vs pixi vs conda (vs ...)
- Desired state
  - Maybe lead with a desired state slide about their knowledge at the end of it
- Example with env-vars, dependencies, etc
- TL;DR
- Baby alpaka crying for every conda install
- Other: Task runners
- Other: Folder structure
- Other: Git
- Other: Documentation-in-tree