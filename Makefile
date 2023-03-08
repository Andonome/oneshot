output=normal

normal: horde_escape.pdf handouts.pdf
horde_escape.pdf: horde_escape.tex intro.tex warren.tex top.tex svg-inkscape/upper_svg-tex.pdf
	touch .hardcore
	pdflatex horde_escape.tex
svg-inkscape/upper_svg-tex.pdf: $(wildcard config/*) images
	pdflatex -shell-escape horde_escape.tex
	pdflatex horde_escape.tex

handouts.pdf: images handouts.tex $(wildcard ex_cs/*)
	rm -f .oneshot .hardcore
	pdflatex -shell-escape handouts.tex

oneshot: oneshot_horde_escape.pdf handouts_oneshot.pdf
oneshot_horde_escape.pdf: oneshot_horde_escape.tex intro.tex warren.tex svg-inkscape/lower_svg-tex.pdf
	touch .oneshot
	pdflatex oneshot_horde_escape.tex
svg-inkscape/lower_svg-tex.pdf: $(wildcard config/*) images
	touch .oneshot
	pdflatex -shell-escape oneshot_horde_escape.tex
	pdflatex oneshot_horde_escape.tex

handouts_oneshot.pdf: images handouts.tex $(wildcard ex_cs/*)
	touch .oneshot
	pdflatex -shell-escape -jobname handouts_oneshot handouts.tex
	rm -f .oneshot

hardcore: hardcore_horde_escape.pdf handouts_hardcore.pdf
hardcore_horde_escape.pdf: hardcore_horde_escape.tex intro.tex warren.tex top.tex siege.tex svg-inkscape/black_tower_f5_svg-tex.pdf
	pdflatex hardcore_horde_escape.tex
svg-inkscape/black_tower_f5_svg-tex.pdf: $(wildcard config/*) images
	touch .hardcore
	pdflatex -shell-escape hardcore_horde_escape.tex
	pdflatex hardcore_horde_escape.tex

handouts_hardcore.pdf: images handouts.tex $(wildcard ex_cs/*)
	touch .hardcore
	pdflatex -shell-escape -jobname handouts_hardcore handouts.tex
	rm -f .hardcore

config/bind.sty:
	git submodule update --init

all: oneshot normal hardcore

clean:
	rm -fr *.slg *slo *sls *.aux *.toc *.acn *.log *.ptc *.out *.idx *.ist *.glo *.glg *.gls *.acr *.alg *.ilg *.ind *.pdf svg-inkscape .hardcore .oneshot

