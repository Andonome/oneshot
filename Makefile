filename=main
out=horde_escape
hardcore=horde_escape_hardcore
branch := $(shell git rev-parse --abbrev-ref HEAD)
output: ${filename}.pdf
${filename}.pdf: $(wildcard *.tex) svg
	pdflatex -jobname=${out} ${filename}.tex
svg:
	pdflatex -jobname=${out} -shell-escape ${filename}.tex
	pdflatex -jobname=${out} ${filename}.tex
	pdflatex -jobname=${out} ${filename}.tex
svg-hardcore:
	$(eval out=hardcore)
	touch .hard
	pdflatex -jobname=${hardcore} -shell-escape ${filename}.tex
	pdflatex -jobname=${hardcore} ${filename}.tex
	pdflatex -jobname=${hardcore} ${filename}.tex
hardcore: svg-hardcore
	make svg-inkscape
	pdflatex -jobname=${hardcore} ${filename}.tex
	rm .hard
all:
	make hardcore
	make
tree:
	[ -e ../config ] || ( echo "You don't have a local config repo" && exit 1 )
	git status
	git subtree -P config pull ../config ${branch}
clean:
	rm -fr *.aux *.toc *.acn *.log *.ptc *.out *.idx *.ist *.glo *.glg *.gls *.acr *.alg *.ilg *.ind *.pdf svg-inkscape .hard
