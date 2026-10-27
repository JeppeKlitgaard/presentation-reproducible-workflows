#import "installation_guide.typ"

#set text(size: 14pt)
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


= Installation Guide: `uv`
#installation_guide.uv


= Installation Guide: `pixi`
#installation_guide.pixi

#v(1fr)
#figure(
  installation_guide.script_file,
)