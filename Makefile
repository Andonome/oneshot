output=normal

normal: config/bind.sty horde_escape.pdf handouts.pdf
horde_escape.pdf: main.tex intro.tex invasion.tex warren.tex top.tex appendix.tex svg-inkscape/upper_svg-tex.pdf svg-inkscape/shaman_svg-tex.pdf
	pdflatex -jobname horde_escape main.tex
svg-inkscape/upper_svg-tex.pdf svg-inkscape/shaman_svg-tex.pdf: images/
	pdflatex -jobname horde_escape -shell-escape main.tex
	pdflatex -jobname horde_escape main.tex
	pdflatex -jobname horde_escape main.tex

handouts.pdf: images handouts.tex $(wildcard ex_cs/*)
	pdflatex -shell-escape handouts.tex

.switch-gls:
	touch -r Makefile .switch-gls

oneshot: config/bind.sty oneshot_horde_escape.pdf oneshot_handouts.pdf .switch-gls
oneshot_horde_escape.pdf: main.tex intro.tex invasion.tex warren.tex appendix.tex svg-inkscape/lower_svg-tex.pdf
	pdflatex -jobname oneshot_horde_escape main.tex
	rm -f .switch-gls
svg-inkscape/lower_svg-tex.pdf: $(wildcard config/*) images .switch-gls
	pdflatex -shell-escape -jobname oneshot_horde_escape main.tex
	pdflatex -jobname oneshot_horde_escape main.tex
	pdflatex -jobname oneshot_horde_escape main.tex
	makeglossaries oneshot_horde_escape

oneshot_handouts.pdf: images handouts.tex $(wildcard ex_cs/*) .switch-gls
	pdflatex -shell-escape -jobname oneshot_handouts handouts.tex
	rm -f .switch-gls

hardcore: config/bind.sty hardcore_horde_escape.pdf hardcore_handouts.pdf
hardcore_horde_escape.pdf: main.tex intro.tex invasion.tex warren.tex top.tex the_tower.tex appendix.tex svg-inkscape/black_tower_f5_svg-tex.pdf
	pdflatex -jobname hardcore_horde_escape main.tex
svg-inkscape/black_tower_f5_svg-tex.pdf: $(wildcard config/*) images
	pdflatex -shell-escape -jobname hardcore_horde_escape main.tex
	pdflatex -jobname hardcore_horde_escape main.tex
	pdflatex -jobname hardcore_horde_escape main.tex

hardcore_handouts.pdf: images handouts.tex ex_cs
	pdflatex -shell-escape -jobname hardcore_handouts handouts.tex

config/bind.sty:
	git submodule update --init

all: oneshot normal hardcore

clean:
	rm -fr *.slg *slo *sls *.aux *.toc *.acn *.log *.ptc *.out *.idx *.ist *.glo *.glg *.gls *.acr *.alg *.ilg *.ind *.pdf svg-inkscape \
	.switch-gls

