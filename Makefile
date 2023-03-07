filename=main
out=horde_escape
hardcore=horde_escape_hardcore
oneshot=horde_escape_oneshot
output: ${filename}.pdf
${filename}.pdf: $(wildcard *.tex) svg
	pdflatex -jobname=${out} ${filename}.tex
config/bind.sty:
	git submodule update --init
svg: config/bind.sty
	pdflatex -shell-escape handouts.tex
	pdflatex -jobname=${out} -shell-escape ${filename}.tex
	pdflatex -jobname=${out} ${filename}.tex
	pdflatex -jobname=${out} ${filename}.tex
svg-hardcore: config/bind.sty
	$(eval out=hardcore)
	touch .hard
	pdflatex -shell-escape handouts.tex
	pdflatex -jobname=${hardcore} -shell-escape ${filename}.tex
	pdflatex -jobname=${hardcore} ${filename}.tex
	pdflatex -jobname=${hardcore} ${filename}.tex
	rm .hard
svg-oneshot: config/bind.sty
	$(eval out=oneshot)
	touch .oneshot
	pdflatex -jobname=${oneshot} -shell-escape ${filename}.tex
	pdflatex -jobname=${oneshot}  ${filename}.tex
	pdflatex -jobname=${oneshot}  ${filename}.tex
	rm .oneshot
hardcore: svg-hardcore
	touch .hard
	make svg-inkscape
	pdflatex -jobname=${hardcore} ${filename}.tex
	rm .hard
oneshot: svg-oneshot
	touch .oneshot
	pdflatex -jobname=${oneshot} ${filename}.tex
	rm .oneshot
all:
	make oneshot
	make hardcore
	make
	handouts
clean:
	rm -fr *.aux *.toc *.acn *.log *.ptc *.out *.idx *.ist *.glo *.glg *.gls *.acr *.alg *.ilg *.ind *.pdf svg-inkscape .hard
