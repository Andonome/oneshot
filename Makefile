output=normal

normal: config/bind.sty images horde_escape.pdf $(wildcard ex_cs/*)
horde_escape.pdf: main.tex intro.tex invasion.tex warren.tex top.tex appendix.tex svg-inkscape/upper_svg-tex.pdf svg-inkscape/shaman_svg-tex.pdf
	pdflatex -jobname horde_escape -shell-escape main.tex
svg-inkscape/upper_svg-tex.pdf svg-inkscape/shaman_svg-tex.pdf: images/
	pdflatex -jobname horde_escape -shell-escape main.tex
	pdflatex -jobname horde_escape main.tex
	pdflatex -jobname horde_escape main.tex

.switch-gls:
	touch .switch-gls

oneshot: config/bind.sty oneshot_horde_escape.pdf .switch-gls
oneshot_horde_escape.pdf: main.tex intro.tex invasion.tex warren.tex appendix.tex svg-inkscape/lower_svg-tex.pdf
	pdflatex -jobname oneshot_horde_escape -shell-escape main.tex
	rm -f .switch-gls
svg-inkscape/lower_svg-tex.pdf: $(wildcard config/*) images .switch-gls
	pdflatex -shell-escape -jobname oneshot_horde_escape main.tex
	pdflatex -jobname oneshot_horde_escape main.tex
	pdflatex -jobname oneshot_horde_escape main.tex

hardcore: config/bind.sty hardcore_horde_escape.pdf
hardcore_horde_escape.pdf: $(wildcard *.tex) svg-inkscape/black_tower_f5_svg-tex.pdf
	pdflatex -jobname hardcore_horde_escape -shell-escape main.tex
svg-inkscape/black_tower_f5_svg-tex.pdf: $(wildcard config/*) images
	pdflatex -shell-escape -jobname hardcore_horde_escape main.tex
	pdflatex -jobname hardcore_horde_escape main.tex
	pdflatex -jobname hardcore_horde_escape main.tex

config/bind.sty:
	git submodule update --init

all: normal hardcore oneshot

clean:
	rm -fr *.slg *slo *sls *.aux *.toc *.acn *.log *.ptc *.out *.idx *.ist *glo \
	*.fls \
	*glg \
	*gls \
	*latexmk \
	*.acr *.alg *.ilg *.ind *.pdf \
	svg-inkscape \
	.switch-gls

