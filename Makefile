output=$(NORMAL)

GENERAL_FILES := config/bind.sty main.tex intro.tex invasion.tex warren.tex top.tex appendix.tex

.switch-gls:
	touch .switch-gls


horde_escape.pdf: $(GENERAL_FILES) horde_escape.fdb_latexmk 
	rm -f .switch-gls
	pdflatex -jobname horde_escape -shell-escape main.tex
horde_escape.fdb_latexmk:
	rm -f .switch-gls
	latexmk -jobname=horde_escape -shell-escape -pdf main.tex


oneshot_horde_escape.pdf: $(GENERAL_FILES) oneshot_horde_escape.fdb_latexmk .switch-gls
	pdflatex -jobname oneshot_horde_escape -shell-escape main.tex
oneshot_horde_escape.fdb_latexmk: .switch-gls
	latexmk -jobname=oneshot_horde_escape -shell-escape -pdf main.tex

hardcore_horde_escape.pdf: $(GENERAL_FILES) hardcore_horde_escape.fdb_latexmk the_tower.tex
	rm -f .switch-gls
	pdflatex -jobname hardcore_horde_escape -shell-escape main.tex
hardcore_horde_escape.fdb_latexmk:
	rm -f .switch-gls
	latexmk -jobname=hardcore_horde_escape -shell-escape -pdf main.tex

config/bind.sty:
	git submodule update --init

all: oneshot_horde_escape.pdf horde_escape.pdf hardcore_horde_escape.pdf

clean:
	rm -fr *.slg *slo *sls *.aux *.toc *.acn *.log *.ptc *.out *.idx *.ist *glo \
	*.fls \
	*glg \
	*gls \
	*latexmk \
	*.acr *.alg *.ilg *.ind *.pdf \
	svg-inkscape \
	.switch-gls

