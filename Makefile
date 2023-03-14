output=normal

normal: horde_escape.pdf handouts.pdf
horde_escape.pdf: horde_escape.tex intro.tex warren.tex top.tex appendix.tex svg-inkscape/upper_svg-tex.pdf
	pdflatex horde_escape.tex
svg-inkscape/upper_svg-tex.pdf: config/ images/
	pdflatex -shell-escape horde_escape.tex
	pdflatex horde_escape.tex
	pdflatex horde_escape.tex

handouts.pdf: images handouts.tex $(wildcard ex_cs/*) cs/
	pdflatex -shell-escape handouts.tex

oneshot: oneshot_horde_escape.pdf handouts_oneshot.pdf
oneshot_horde_escape.pdf: oneshot_horde_escape.tex intro.tex warren.tex appendix.tex svg-inkscape/lower_svg-tex.pdf
	pdflatex oneshot_horde_escape.tex
svg-inkscape/lower_svg-tex.pdf: $(wildcard config/*) images
	pdflatex -shell-escape oneshot_horde_escape.tex
	pdflatex oneshot_horde_escape.tex
	pdflatex oneshot_horde_escape.tex
	makeglossaries oneshot_horde_escape

handouts_oneshot.pdf: images handouts.tex $(wildcard ex_cs/*) cs/
	pdflatex -shell-escape -jobname handouts_oneshot handouts.tex

hardcore: hardcore_horde_escape.pdf handouts_hardcore.pdf
hardcore_horde_escape.pdf: hardcore_horde_escape.tex intro.tex warren.tex top.tex siege.tex appendix.tex svg-inkscape/black_tower_f5_svg-tex.pdf
	pdflatex hardcore_horde_escape.tex
svg-inkscape/black_tower_f5_svg-tex.pdf: $(wildcard config/*) images
	pdflatex -shell-escape hardcore_horde_escape.tex
	pdflatex hardcore_horde_escape.tex
	pdflatex hardcore_horde_escape.tex

handouts_hardcore.pdf: images handouts.tex cs/
	pdflatex -shell-escape -jobname handouts_hardcore handouts.tex

config/bind.sty:
	git submodule update --init

all: oneshot normal hardcore

clean:
	rm -fr *.slg *slo *sls *.aux *.toc *.acn *.log *.ptc *.out *.idx *.ist *.glo *.glg *.gls *.acr *.alg *.ilg *.ind *.pdf svg-inkscape

