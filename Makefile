filename=main
out=oneshot
branch := $(shell git rev-parse --abbrev-ref HEAD)
output: ${filename}.pdf
${filename}.pdf: $(wildcard *.tex) svg-inkscape
	pdflatex -jobname=${out} ${filename}.tex
siege: svg-inkscape/black_tower_base_svg-tex.pdf
svg-inkscape/black_tower_base_svg-tex.pdf:
	pdflatex -jobname=${out} -shell-escape ${filename}.tex
svg-inkscape:
	pdflatex -jobname=${out} -shell-escape ${filename}.tex
	pdflatex -jobname=${out} ${filename}.tex
	pdflatex -jobname=${out} ${filename}.tex
hardcore:
	touch .hard
	make siege
	make
	rm .hard
all:
	make hardcore
	mv oneshot.pdf oneshot_hardcore.pdf
	make
tree:
	[ -e ../config ] || ( echo "You don't have a local config repo" && exit 1 )
	git status
	git subtree -P config pull ../config ${branch}
clean:
	rm -fr *.aux *.toc *.acn *.log *.ptc *.out *.idx *.ist *.glo *.glg *.gls *.acr *.alg *.ilg *.ind *.pdf svg-inkscape .hard
