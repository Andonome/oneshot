filename=example
output: ${filename}.pdf
${filename}.pdf: ${filename}.tex bind.sty monsters.sty
	pdflatex ${filename}.tex
new:
	if [ ! -d .git ] && [ -e ../.git ]
	then
		cp -n main.tex .gitignore ..
	fi
clean:
	rm -r *.{pdf,aux,toc,acn,acr,log,ptc,out,idx,ist,alg,glo} 2>/dev/null
