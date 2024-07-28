include config/vars

.PHONY: all
all: oneshot_horde_escape.pdf horde_escape.pdf hardcore_horde_escape.pdf

WARREN := main.tex commands.tex images/ glossary.tex commands.tex intro.tex invasion.tex warren.tex appendix.tex handouts.tex appendix.tex ex_cs config/

UPPER_WARREN := $(WARREN) top.tex tour.tex

OUTSIDE_WARREN := $(UPPER_WARREN) the_tower.tex 

config/vars:
	git submodule update --init

.switch-gls:
	touch .switch-gls

config/booklet.pdf:
	make -C config booklet.pdf

oneshot_horde_escape.pdf: config/booklet.pdf $(WARREN) rules.tex | .switch-gls
	@$(COMPILER) -jobname=oneshot_horde_escape main.tex
	@pdfunite $@ config/booklet.pdf /tmp/out.pdf
	@mv /tmp/out.pdf $@

horde_escape.pdf: $(UPPER_WARREN)
	@$(RM) .switch-gls
	@$(COMPILER) -jobname=horde_escape main.tex

hardcore_horde_escape.pdf: $(OUTSIDE_WARREN) the_tower.tex
	@$(RM) .switch-gls
	@$(RUN) -jobname=hardcore_horde_escape main.tex
	@$(COMPILER) -jobname=hardcore_horde_escape main.tex


clean:
	$(CLEAN)
