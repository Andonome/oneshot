include config/vars

WARREN := main.tex commands.tex images/ glossary.tex intro.tex invasion.tex warren.tex appendix.tex handouts.tex appendix.tex images/extracted/lower-handout.svg

UPPER_WARREN := $(WARREN) top.tex tour.tex images/extracted/upper-handout.svg

OUTSIDE_WARREN := $(UPPER_WARREN) the_tower.tex 

config/vars:
	git submodule update --init

images/extracted/:
	mkdir -p $@
	echo '*' > $@.gitignore

images/extracted/lower-handout: images/Dyson_Logos/lower.svg images/extracted/
	inkscape $< --select=layer2 --actions=delete -l --export-filename $@.svg
	inkscape $@.svg --export-area=159:1936:3020:3039 --export-filename $@-1.png
	magick $@-1.png -fill white -channel-fx '| gray=>alpha' -draw "rectangle 1680,0 2460,190" $@-1.jpg

	inkscape $@.svg --export-area=422:502:3463:2133 --export-filename=$@-2.png
	magick $@-2.png -fill white -channel-fx "| gray=>alpha" -draw "rectangle 0,0 1000,900" -draw "rectangle 0,0 2000,300" -draw "rectangle 0,0 1330,470" $@-2.jpg

images/extracted/upper-handout.svg: images/Dyson_Logos/upper.svg images/extracted/
	inkscape $< --export-id-only --export-id=layer3 -l --export-filename $@

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
