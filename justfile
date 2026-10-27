compile:
    typst compile --pdf-standard a-2b --input pympress=false presentation.typ
    typst compile --pdf-standard a-2b --input pympress=false --input handout=true presentation.typ presentation_handout.pdf
    typst compile --pdf-standard a-2b --input pympress=true presentation.typ presentation_pympress.pdf

    # pdfpc support
    # typst eval --root . --in presentation.typ 'query(<pdfpc-file>).first().value' > presentation.pdfpc

    typst compile --pdf-standard a-2b installation_guide_a4.typ
