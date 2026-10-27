#import "deps.typ": codly

#let uv = [
0. (Install `uv`): #link("https://docs.astral.sh/uv/")
+ Make project folder:
  - `mkdir danbias-hackathon`
  - `cd danbias-hackathon`
+ Set up `project.toml`
  - `uv init --bare --python 3.14`
+ Install `qim3d`:
  - `uv install qim3d`
+ Set up a script (`00_download_dataset.py`)
+ Run script:
  - `uv run python 00_download_dataset.py`
]

#let script_file = [
#show: codly.lang-set_(display-name: false, display-icon: false)
#codly.new(
  read("assets/00_download_dataset.py"),
  lang: "py",
  file: "00_download_dataset.py",
)
]

#let pixi = [
0. (Install `pixi`): #link("https://pixi.prefix.dev/latest/#installation")
+ Make project folder:
  - `mkdir danbias-hackathon`
  - `cd danbias-hackathon`
+ Set up `project.toml`
  - (or use `pixi.toml` if omitting format)
  - `pixi init --format pyproject`
+ Install python
  - `pixi add python=3.14`
+ Install `qim3d`:
  - `pixi add --pypi qim3d`
+ Set up a script (`00_download_dataset.py`, see left column)
+ Run script:
  - `pixi run python 00_download_dataset.py`
]