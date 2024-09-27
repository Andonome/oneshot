include config/vars

WARREN := main.tex commands.tex images/ glossary.tex intro.tex invasion.tex warren.tex appendix.tex handouts.tex appendix.tex

UPPER_WARREN := $(WARREN) top.tex tour.tex

OUTSIDE_WARREN := $(UPPER_WARREN) the_tower.tex 

config/vars:
	git submodule update --init

images/extracted/:
	mkdir -p $@
	echo '*' > $@.gitignore

images/extracted/lower-handout.svg: images/extracted/
	inkscape images/Dyson_Logos/lower.svg --export-id-only --export-id=layer1 -l --export-filename $@

.PHONY: all
all: $(TITLE).pdf Extended_$(TITLE).pdf Hardcore_$(TITLE).pdf

$(DROSS)/characters.pdf: ex_cs/
	$(COMPILER) -jobname=characters ex_cs/all.tex

config/rules.pdf:
	make -C config rules.pdf

$(DBOOK): $(WARREN) | LOCTEX HANDOUTS STYLE_FILES EXTERNAL .switch-gls
	@$(COMPILER) main.tex
$(TITLE).pdf: $(DROSS)/$(BOOK).pdf $(DROSS)/characters.pdf config/rules.pdf
	pdfunite $^ $@

$(DROSS)/extended_$(BOOK).pdf: $(UPPER_WARREN)
	@$(COMPILER) -jobname=extended_$(BOOK) main.tex
Extended_$(TITLE).pdf: $(DROSS)/extended_$(BOOK).pdf $(DROSS)/characters.pdf
	pdfunite $^ $@

$(DROSS)/hardcore_$(BOOK).pdf: $(OUTSIDE_WARREN) the_tower.tex
	@$(COMPILER) -jobname=hardcore_$(BOOK) main.tex
Hardcore_$(TITLE).pdf: $(DROSS)/hardcore_$(BOOK).pdf
	@$(CP) $< $@

.PHONY: clean
clean:
	$(CLEAN)
	$(RM) -r images/extracted
