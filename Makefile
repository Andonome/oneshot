include config/vars

WARREN := main.tex commands.tex images/ glossary.tex intro.tex invasion.tex warren.tex appendix.tex handouts.tex appendix.tex ex_cs config/

UPPER_WARREN := $(WARREN) top.tex tour.tex

OUTSIDE_WARREN := $(UPPER_WARREN) the_tower.tex 

config/vars:
	git submodule update --init

.PHONY: all
all: $(TITLE).pdf Extended_$(TITLE).pdf Hardcore_$(TITLE).pdf

config/booklet.pdf:
	make -C config booklet.pdf

$(DBOOK): LOCTEX HANDOUTS STYLE_FILES EXTERNAL config/booklet.pdf | .switch-gls
	@$(COMPILER) main.tex
	@pdfunite $@ config/booklet.pdf /tmp/out.pdf
	@mv /tmp/out.pdf $@
	@$(RM) .switch-gls

$(DROSS)/extended_$(BOOK).pdf: $(UPPER_WARREN)
	@$(COMPILER) -jobname=extended_$(BOOK) main.tex
Extended_$(TITLE).pdf: $(DROSS)/extended_$(BOOK).pdf
	@$(CP) $< $@

$(DROSS)/hardcore_$(BOOK).pdf: $(OUTSIDE_WARREN) the_tower.tex
	@$(COMPILER) -jobname=hardcore_$(BOOK) main.tex
Hardcore_$(TITLE).pdf: $(DROSS)/hardcore_$(BOOK).pdf
	@$(CP) $< $@

.PHONY: clean
clean:
	$(CLEAN)
