#import "deps.typ": grayness.image-transparency
// #import "deps.typ": ccicons.cc-by-nc-nd-badge
#import "deps.typ": typsium.ce
#import "deps.typ": semantrix.vv
#import "deps.typ": codly, codly-languages.codly-languages
#import "deps.typ": dtree.dtree

// Slides
#import "deps.typ": dutten.slides, fletcher
#import fletcher: edge, node
#import slides: progress-marker-both, progress-marker-lower, progress-marker-upper, touying
#import touying: *

// #import "@preview/unify:0.8.1": add-unit, num, numrange, qty, qtyrange, unit
// #import "@preview/zero:0.7.0": num as znum, quan
// #import "@preview/suboutline:0.3.0": suboutline
#import "qim.typ"
#import "utils.typ": *

#show: codly.lang-set_(languages: codly-languages)
#let fletcher-diagram = touying-reducer.with(reduce: fletcher.diagram, cover: fletcher.hide)

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
  config-common(show-bibliography-as-footnote: true, enable-pdfpc: true),
  pympress: true,
  pympress-prioritise-sys-inputs: true,
)

#set text(size: 20pt)
#show figure.caption: set text(size: 16pt)
#set highlight(extent: 2pt, fill: gray.transparentize(70%), radius: 3pt)
#show raw: highlight
#show link: set text(fill: navy.lighten(20%))
#show link: it => {
  if it.body == it.dest {
    set text(fill: navy.lighten(20%))
  }
  it
}
#show link: underline.with(offset: 2.5pt)
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
  Qim + DanBIAS Hackathon,\
  #context document.date.display()
  #v(3cm)
  Jeppe Klitgaard\
  #[
    #set text(size: 0.7em)
    #link("mailto:s250250@dtu.dk")
  ]
]

// #show: magic.bibliography-as-footnote.with(bibliography("references.bib", title: none))
== Outline <outline>
#speaker-note[
#v(1fr)
Someone once described me as a person that would rather be _right_ than _reasonable_
- Relatedly, I have since stopped seeing this person, which perhaps reinforces their claim
#v(1em)
]
- Reproducibility and why it matters

- Packaging ecosystems in Python

- Dependency theory and management
  - Lockfiles

- Helpful mental models for workflows

- A fly-by of other tools

- Workflow tips and tricks

- Get environment set up for today

#pause
- Fairly opinionated presentation
  - _Heckling is actively encouraged!_

== Problem: Reproducibility
#speaker-note[
That was my _one_ joke for the presentation; rest will be deadly serious.

Reproducibility rates vary widely across disciplines:
- Psychology research: ≈ 40%
- Cancer biology research: ≈ 10%
- (Not from the Nature survey, though referenced by it)
- Physics and chemistry generally more confident in literature

Computation _should_ be easy.
- Deterministic process, at least until quantum computing

Kohn’s Second Law: _“An experiment is reproducible until another laboratory tries to repeat it.”_
]
#cols[
  - No science without reproducibility
  - Nature Survey 2016 @baker1500ScientistsLift2016:
    - 52% ($N=1576$): _significant reproducibility crisis_
    - >70% have failed to reproduce other scientist's experiments
    - >50% have failed to reproduce their own experiments

  - Computations and analyses are easy to reproduce, _right?_
][
  #figure(
    image("assets/nature-survey.svg"),
    numbering: none,
    caption: none,
  )
]

== Reproducible Environments in Python
- Have you failed to run code due to irreproducible environment?
  - A colleagues code?
  - A paper's code?
  - Your own code?

#pause
- A _"fun"_ experiment to try: rerun your own code from 1/3/5 years ago
  - Can you get it up and running? Easily?
  - Could someone reasonably get this up and running?
  - Me:
    - Anything since using tools recommended here: Yes!
    - ≈ 3 years ago (`poetry`): with some effort; before that: no

#pause
- Conclusion:
  - Good reproducibility is easy with modern tools
  - Brazen statement: _irreproducible environments unacceptable in 2026!_

== Desired State
- Broadly: package managers follow _either_:
  - "Modern": *Desired state* pattern and *declarative* specification
  - "Legacy": *Accumulated state* pattern and *imperative* actions

#pause
- Modern: `uv`, `pixi`, (`poetry`)
  - _Declarative_ specification: `pyproject.toml` + (`uv.lock`) + (`.python-version`)
  - `uv run ...` ensures environment has _desired state_ before running

#pause
#speaker-note[
Conda can get closer to _desired state_ pattern with `env.yml`, but no guarantee/invariant is produced

Skip: joke on politicians prefering desired state over imperative actions

God also preferred this pattern:
- _Let there be light_ in Book of Genesis
]
- Legacy: `pip`, `conda`, ...
  - Environment is the _accumulated state_ of a series of _imperative_ actions
    - `conda env create`, `conda install`, `pip install`, `pip uninstall`
    - Consequence: environment is not specified anywhere!

#pause
- `uv` and `pixi` are also _much_ faster than legacy options (_try this!_)

#pagebreak(weak: true)
#speaker-note[
The desired state after this presentation is...

_Italicised are joke-y_.
]
After this presentation you will:

- Know exactly what is meant by _reproducible environment_

- Understand what makes modern package managers superior

- Appreciate how lockfiles work and promote reproducibility

- _Have a strong, inexplicable urge to uninstall `conda`?_

- _Spread the gospel of `pixi`, `uv`, and computational hygiene_

== Tale of Two Ecosystems

#block(
  inset: (x: 0pt),
  width: 100%,
)[
#show table.cell.where(x: 0): set text(weight: "bold")
#table(
  columns: (auto, 1fr, 1fr),
  inset: (left: 0pt, right: 24pt, y: 12pt),
  align: left + top,
  // No grid: orange rule under the logos, hairlines between rows
  stroke: (x, y) => if y == 1 {
    (top: 2pt + qim.orange)
  } else if y > 1 {
    (top: 1pt + qim.hairline)
  },

  none,
  align(horizon + center, image("assets/PyPI_logo.svg", height: 3em)),
  align(horizon + center, image("assets/Conda_logo.svg", height: 1.6em)),

  [Tools],
  [pip, uv, pixi, poetry, hatch, PDM, ...],
  [(mini)conda, pixi, (micro)mamba, miniforge, ...],

  [Scope],
  [Python-centric],
  [Language-agnostic],

  [Specification],
  [PEP 621: `pyproject.toml`],
  [`environment.yml`],

  [Index],
  [Usually centralised],
  [Channels, often decentralised],
)
]
- `pixi` is the _only_ tool that straddles both somewhat well
- Common: `conda` to install Python + packages, _also_ `pip` to install PyPI packages
  - _Bad idea_: dependency resolution does not work (except `pixi`)

== Package Managers in Python
#speaker-note[
  Very briefly cover; slide partially serves as reference

  Touch upon:
  - `conda`, `pip` don't really support locking (discussed later)
  - `uv` and `pixi`
]

#let yes = "✅"
#let no = "❌"
#let vertical(body) = rotate(-90deg, reflow: true, body)
// Label + arrowhead; the shaft is a table.vline so it spans exactly the body rows
#let awfulness-axis = {
  place(bottom + right, dx: 8pt + 0.3em, dy: 0.2em, polygon(fill: qim.grey, (0em, 0em), (0.6em, 0em), (0.3em, 0.6em)))
  rotate(-90deg, reflow: true, text(fill: qim.grey, style: "italic")[awfulness])
}

#align(center)[
#set text(size: 17pt)
#show table.cell.where(x: 2): set text(weight: "bold")
#table(
  // Columns: axis, spacer, tool, spec, lockfile, then checkmarks
  columns: (auto, 20pt, auto, auto, auto) + (auto,) * 6,
  inset: (x: 10pt, y: 6pt),
  align: (x, y) => if y == 0 { (if x < 5 { left } else { center }) + bottom } else if x < 5 { left + horizon } else { center + horizon },
  // No grid: orange rule under the header, hairlines between rows, rule between text and checkmark columns
  stroke: (x, y) => if x > 1 { (
    top: if y == 1 { 2pt + qim.orange } else if y > 1 { 1pt + qim.hairline },
    left: if x == 5 and y > 0 { 1pt + qim.hairline },
  ) },

  none,
  none,
  none,
  [Specification],
  [Lockfile],
  vertical[PyPI],
  vertical[Conda],
  vertical[Manages\ Python],
  vertical[Desired\ State],
  vertical[Multi-Env#footnote[from a single specification]],
  vertical[Tasks],

  table.vline(x: 1, start: 1, stroke: 2pt + qim.grey),
  table.cell(rowspan: 5, inset: (left: 0pt, right: 8pt, y: 0pt), align: horizon, awfulness-axis),
  table.cell(rowspan: 5, none),
  [uv], [`pyproj.toml`], [`uv.lock` \ `pylock.toml`],
  yes, no, yes, yes, no, no,

  [pixi], [`pyproj.toml`\ `pixi.toml`], [`pixi.lock`],
  yes, yes, yes, yes, yes, yes,

  [poetry], [`pyproj.toml`], [`poetry.lock`],
  yes, no, no, [(#yes)], no, no,

  [pip], [`req.txt` \ `pyproj.toml`], [#no#footnote[recently: experimental `pylock.toml` support; `pip freeze > requirements.txt` is just a specific solution for _current set of external constraints_, see later.]],
  yes, no, no, no, no, no,

  [conda], [`env.yml`], no,
  [#no#footnote[`pip` support in `env.yml` is just blind `pip install` step after regular resolution. `pixi` constraints second round `pypi` solve using `conda` packages and a mapping]], yes, yes, no, no, no,
)
]

Decent alternatives exist in PyPI world: _hatch, PDM_:
- Arguably some of these are better than _poetry_.

== Dependency solvers
#let constraint(body) = text(fill: qim.grey, raw(body))
#let dependency-dg(include-qim3d) = {
  set highlight(fill: none)
  fletcher-diagram(
    node-stroke: 1.5pt + qim.grey,
    node-fill: white,
    node-corner-radius: 4pt,
    node-inset: 10pt,
    edge-stroke: 1.5pt,
    spacing: (3em, 3em),

    node((0, 0), raw("project"), stroke: 1.5pt + qim.red, name: <project>),
    node((0, 2), raw("numpy"), name: <numpy>),
    edge(<project>, <numpy>, "-|>", label: constraint(">=2.2.0"), label-side: left),
    ..if include-qim3d {
      (
        node((-1, 1), raw("qim3d"), name: <qim3d>),
        edge(<project>, <qim3d>, "-|>", label: constraint(">=1.6.0"), label-side: right),
        edge(<qim3d>, <numpy>, "-|>", label: constraint(">=2.3.0"), label-side: right),
      )
    },
  )
}

#speaker-note[
  Python Enhancement Proposals (PEPs) are like _fatwas_ for Python. The #emph[mufti]s in the Steering Council rule on them.
]
#cols(columns: (2fr, 1fr))[
  #link("https://peps.python.org/pep-0621/")[PEP 621] defines the `pyproject.toml` standard#footnote[PEP 621 specifically covers the `[project]` table, not whole `pyproject.toml`]
  - All modern Python _should_ declare dependencies this way
  - `requirements.{txt,in}` never formalised!

  Dependencies form a _directed graph_ (DG)
  - Environment must satisfy all constraints of DG

  #align(center, scale(dependency-dg(true), 85%, reflow: true))
][
  #show: codly.lang-set_(display-name: false, display-icon: false)
  #codly.new(
    read("assets/pyproject__dependencies.toml"),
    lang: "toml",
    file: "pyproject.toml",
    ranges: ((1, 1), (3, 5), (7, 8)),
    smart-skip: true,
  )
]

#pagebreak(weak: true)
#cols(columns: (2fr, 1fr))[
Possible solutions to dependency resolution:
- #strike[`numpy==2.1.0`]
- `numpy==2.2.0`
- `numpy==2.3.0`
- `numpy==2.3.1`
- ...
][
  #align(right, scale(dependency-dg(false), 80%, reflow: true))
]

#line(length: 100%)
#pause

#cols(columns: (2fr, 1fr))[
- #strike[`numpy==2.1.0`]
- #red[#strike[`numpy==2.2.0`]]
- `numpy==2.3.0`
- `numpy==2.3.1`
- ...
][
  #align(right, scale(dependency-dg(true), 80%, reflow: true))
]

#pagebreak(weak: true)
#cols(columns: (2fr, 1fr))[
Easy to create graph that cannot be solved
- suppose `project` required `numpy<2`
- `qim3d>=1.6.0` requires `numpy>=2.3.0`

#pause
Generally many solutions
- `numpy==2.3.0`
- `numpy==2.3.1`, ...
// - ...

#skip[
Without upper constraints (`numpy>=2.2.0,<3`)#footnote[Upper constraints are discouraged in libraries and likely unnecessary in tools/analysis projects, lockfiles are better. See #cite(<schreinerShouldYouUse2021>, form: "prose")] breakage likely in future
]
][
  #align(center, scale(dependency-dg(true)))
]

#pause
#skip[
#boxed[
Aside: _Semantic Versioning_ (SemVer)
- If `0.y.z`: breaking changes require increment of `y`#footnote[Strictly by specification increment of `z` is sufficient, but widely adopted convention does not allow this]
- If `x.y.z`: breaking changes require increment of `x`
- Python world generally does not abide by SemVer, _sadly!_
]
]
#speaker-note[
Constraints can be more complex, e.g.:
- `>=2.2,!=2.2.1`
]

== Lockfiles
- Dependency resolutions also subject to _external constraints_ with _feasible set of external constraints_:
  - Example external constraint: `numpy==2.3.0` requires `python>=3.13`//#footnote[Strictly speaking `numpy` can be built for `python>=3.11`, but only ships wheels for `python>=3.13`]
  - Example feasible set: `project.requires-python >=3.13,<3.16`
  - Operating system, architecture, Python version, Python implementation,  extras

- Lockfiles provide one _specific_ solution for any given set of _feasible external constraints_

- Given *lockfile* + *external constraints* the *desired state* is fully specified#footnote[Some caveats apply, e.g. system libraries and drivers, build tools are not captured in `uv`, but can be in `pixi`]
  - Also when dependencies release new versions
  - Environment is _deterministic_ and _reproducible_, hurray!

- *Importantly*: lockfile belongs to a _project_, not a _package_!
  - If library `qim3d` has a lockfile, dependents of `qim3d` do not use it
  - They use their own lockfiles, if they have them

#pagebreak(weak: true)
Lockfiles serve different purposes in different scenarios

Library:
- Ensures deterministic _Continuous Integration_ (CI) builds
- Removes computationally expensive dependency resolution step
- All developers have same environment, _reduces "works on my machine"_ issues
- #skip[_Some libraries avoid lockfiles to find breakages against dependencies during testing/development; both can be done simultaneously_]

#pause
Tool:
- Consistent builds of tool

#pause
Analysis:
- Reproducible environment and workflow, thus reproducible science!

#pause
#skip[Other benefits: reduces susceptibility to supply chain attacks]

#pagebreak(weak: true)
#speaker-note[
Let's consider what is desirable for an analysis project.

For aside: maybe mention `CIL` only supports 3.13?
]
For a data analysis project reproducibility trumps flexibility:

- Don't need project to support many Python versions, the fewer the better!

- Thus: restrict _feasible external constraints_
  - `project.requires-python = "==3.Y.*"` for some `Y`
  - Pixi: `platforms = ["linux-64"]`
  - Uv: `tool.uv.environments = ["sys_platform == 'linux'"]`

#pause
#v(1fr)
- Aside: Use a recent Python version for new projects!
  - 3.15 if dependencies support it
  - 3.14 otherwise


== Analysis as a Directed Acyclic Graph (DAG)
#cols(columns: (1fr, auto), gutter: 2cm)[
- Flow from raw data to results should have a clear mental model
  - Can be very complex
  - Always acyclic
- Tip: Have folder in project with steps
][
#set highlight(fill: none)
#dtree(spacing: 0pt, size: 16pt, ```

  analysis
    00_fetch_data.py
    01_preprocess_data.ipynb
    02_process_data.ipynb
    03_train_model.ipynb
    04_evaluate_summary.ipynb
  pyproject.toml
  uv.lock
  ...
```)
]


#let step(body) = text(fill: qim.grey, raw(body))
#let quip(body) = text(size: 0.75em, fill: qim.grey, style: "italic", body)
#let analysis-dg(..args) = {
  set highlight(fill: none)
  set text(size: 15pt)
  fletcher-diagram(
    node-stroke: 1.5pt + qim.grey,
    node-fill: white,
    node-corner-radius: 4pt,
    node-inset: 10pt,
    edge-stroke: 1.5pt,
    spacing: (6em, 2em),
    node((0, -0.5), [Raw\ data 1], width: 5.5em, height: 3em, name: <raw1>),
    node((-1, 0.5), [Raw\ data 2], width: 5.5em, height: 3em, name: <raw2>),
    node((0, 0.5), [Processed\ data 2], width: 5.5em, height: 3em, name: <processed2>),
    node((1, 0), [Processed\ data], width: 5.5em, height: 3em, name: <processed>),
    node((2, 0), [Training\ data], width: 5.5em, height: 3em, name: <training>),
    edge(<raw2>, <processed2>, "-|>", label: step("preprocess()")),
    // Both sources feed the same process() step
    edge(<raw1>, <processed>, "-|>"),
    edge(<processed2>, <processed>, "-|>"),
    node((0.45, 0), step("process()"), stroke: none, fill: none),
    edge(<training>, <results>, "-|>", label: step("train()")),
    ..args,
  )
}

#v(1fr)
#align(center, analysis-dg(
  node((3, 0), [Results], width: 5.5em, height: 3em, stroke: 1.5pt + qim.red, name: <results>),
  edge(<processed>, <training>, "-|>", label: step("split()")),
))
#v(1fr)
#skip[
#set text(size: 0.7em)
_Slide heavily inspired by presentation by Niels Skovgaard Jensen, PhD at DTU Compute_
]

#pagebreak(weak: true)
#speaker-note[
  Okay if it looks like this at some point, just not at the end!
]
#align(center, analysis-dg(
  node((3, 0), [Results?], width: 5.5em, height: 3em, stroke: 1.5pt + qim.red, name: <results>),
  node((1, 1), [Filtered\ data], width: 5.5em, height: 3em, name: <filtered>),
  edge(<processed>, <training>, "-|>", bend: 12deg, label: step("Cell 7?")),
  edge(<processed>, <training>, "-|>", bend: -12deg),
  edge(<processed>, <processed>, "-|>", dash: "dashed", bend: 130deg, loop-angle: 90deg, label: quip["It only works when I run it twice"]),
  edge(<results>, <training>, "-|>", bend: -40deg, label: quip[Run cell 3 again], label-side: right),
  edge(<results>, <processed>, "-|>", bend: -55deg, label: quip[Went for coffee and forgot where I came from], label-side: right),
  edge(<results>, <processed>, "-|>", dash: "dashed", bend: 25deg, label: align(center, step("Cell 12?") + linebreak() + quip[Why is the test data not defined???]), label-side: left),
  edge(<processed2>, <filtered>, "-|>", label: step("?"), label-side: right),
  edge(<processed>, <filtered>, "-|>", bend: -30deg, label: step("to_pandas"), label-pos: 55%, label-side: right),
  edge(<filtered>, <processed>, "-|>", bend: -30deg, label: step("to_numpy"), label-side: right),
  edge(<results>, <raw2>, "-|>", bend: 45deg, label: quip[I'll just restart the kernel...], label-side: left),
))
#v(1fr)
#skip[
#set text(size: 0.7em)
_Slide heavily inspired by presentation by Niels Skovgaard Jensen, PhD at DTU Compute_
]


== Other Tools for Reproducibility
- Some sort of version control (VCS), usually `git` + `Git{Hub,Lab}` is a must
  - #link("https://git-lfs.com/", [Git LFS]) for binary files in VCS

- For notebooks, #link("https://marimo.io/", [Marimo]) can help with reproducibility and VCS

- A task runner can be used to make self-documenting workflows easily
  - either #link("https://just.systems/", [`just`]) or #link("https://pixi.prefix.dev/latest/", [`pixi`])

- A good #link("https://pre-commit.com/", [pre-commit]) setup can keep things neat
  - Use #link("https://prek.j178.dev/", [`prek`]) instead of standard `pre-commit`
  - Sensible starting point could be #link("https://github.com/JeppeKlitgaard/ezhpcy/blob/master/.pre-commit-config.yaml", [this])

- #link("https://typst.app/", [Typst]) or Markdown to easily make documents and slides accompanying code

== Miscallenous Tips and Tricks
#speaker-note[
Some are specific to the type of work Qim often does:
- Smaller cases with researchers that are then handed over
]

- Put as much as possible into a single project repository
  - (Sanitised) notes from meetings
  - Slides from meetings
  - Documents about project
- Create `README.md` files in directories that terse explain them
- Tidy up before handing over project
- Create `handover` folder in VCS and collect results and summaries there
- Create a `README.md` in the root of the project guiding the user
- Ask yourself and an LLM whether project can be easily understood and reproduced

#v(1fr)

#skip[
_An attempt at following some of these ideas can be found #link("https://github.com/qim-center/consult-xct-compression")[here]_
]

== Aside: Computational Analysis as an Experimental Science
#speaker-note[
  Consider skipping
]
// #skip[
How I was taught experimental science:
- Contemporaneously record details in log book
- Tersely record details required to reproduce experiment
- Every week for a year:
  + Do experiment
  + Hand in black log book
  + Get slip listing marks for last weeks experimental protocol
  + Get scolded for protocol violations
  + Marks deducted for any missing detail, _no exceptions!_

Somewhat brutal, but important: _"academic rigour"_
// ]
#pagebreak(weak: true)

We should hold computational analysis to the same standard!

Chemistry would not accept:
- "we titrate with #ce[AgNO3] to determine #ce[Cl-] concentration"
#let _boxer(body) = box(fill: std.green.transparentize(50%), radius: 3pt, outset: 5pt, {
  set highlight(fill: none)
  body
})
#block(
  inset: (x: 0pt),
  width: 100%,
)[
#show table.cell.where(x: 0): set text(weight: "bold")
#show table.cell.where(y: 0): set text(weight: "bold")
#table(
  columns: (auto, 1fr, 1fr, 1fr),
  inset: (x, y) => (left: if x == 0 { 0pt } else { 12pt }, right: 12pt, y: 12pt),
  align: left + top,
  // No grid: orange rule under the header, hairlines between rows and body columns
  stroke: (x, y) => (
    top: if y == 1 { 2pt + qim.orange } else if y > 1 { 1pt + qim.hairline },
    left: if x > 0 and y > 0 { 1pt + qim.hairline },
  ),

  none, [Computation], [Physics], [Chemistry],

  [Insufficient],
  [Code, no environment spec],
  [determined $μ(vv(x))$ with X-ray CT],
  [titrate with #ce[AgNO3] ...],

  [Acceptable],
  [Code, #_boxer[`pyproject.toml` + `uv.lock`]],
  [determined $μ(vv(x))$ with X-ray CT at #_boxer[$80 "kV"$, ...]],
  [titrate with #_boxer[$0.05 "M"$] #ce[AgNO3] ...],
)
]

== TL;DL
- Modern tools require a bit of adjustment
  - Big payoff for *productivity* and *reproducibility*

- Always use a *project specficiation* (`pyproject.toml`) and *lockfile* for projects
  - If possible, restrict allowed Python versions to just one (`3.14.*`)

- Computational analysis is an *experiemental science*
  - Adopt *strict experimental protocol*!

#pause
- Mnemonic reminder: _Baby got back_ by Sir Mix-a-Lot
  - _"I like big *locks* and I cannot lie"_
  - _My ana#strong[conda don't] want none unless you got buns, hun_

== Desired State Revisited

After this presentation you will:

- Know exactly what is meant by _reproducible environment_

- Understand what makes modern package managers superior

- Appreciate how lockfiles work and promote reproducibility

- _Have a strong, inexplicable urge to uninstall `conda`?_

- _Spread the gospel of `pixi`, `uv`, and computational hygiene_

#pause
#speaker-note[
  Maybe easier to tell after hands-on exercises
]
#[
#set align(center)
#set text(size: 40pt)

*Did it work?*

#pause
#set text(size: 24pt)
Let me know using the main document!
]

== Questions?
#alternatives[

][
Jeppe from the past:
- I went over, so we don't have time for them anyway
][
Softball questions for myself:
+ Most people use `conda`, so why should I switch?
  - Most people do not use `conda`, maybe in some very small bubbles this is the case
  - PyTorch dropped 1st party `conda` support more than 2 years ago due to low usage (3.7% compared to PyPI)

+ This seems like an awful lot of work, why bother?
  - Surprisingly not that much work
  - Think of the time you save by never being in a weirdly broken environment!
]

#slides.progress-marker-upper

== Further Reading
- #link("https://github.com/pytorch/pytorch/issues/138506", [PyTorch dropping conda support])

- #link("https://iscinumpy.dev/post/bound-version-constraints/", [Should You Use Upper Bound Version Constraints?])

- #link("https://semver.org/", [Semantic Versioning Specification])

- #link("https://pydevtools.com/handbook/explanation/uv-vs-pixi-vs-conda-for-scientific-python/", [uv vs pixi vs conda for Scientific Python])

== Bibliography
#bibliography("references.bib", title: none)
// #place(hide(bibliography("references.bib")))

== Meta
The source code for these slides are available at:
- #link("https://github.com/JeppeKlitgaard/presentation-reproducible-workflows", [`github.com/JeppeKlitgaard/presentation-reproducible-workflows`])

== Next: Set up environment for today
#speaker-note[
I usually start in `uv` unless I know I have to use Conda ecosystem
- Have only one tool I use that only supports Conda
- Won't mention names, as that would be CILly a thing to do for my career prospects.
]
#import "installation_guide.typ"
#set text(size: 0.75em)
#cols(columns: (1fr, 1fr), gutter: 2cm)[
#installation_guide.uv

#installation_guide.script_file
][
#installation_guide.pixi
]
