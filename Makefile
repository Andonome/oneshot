EXTERNAL_REFERENTS = core stories judgement

pdfs += Extended_$(TITLE).pdf
pdfs += Hardcore_$(TITLE).pdf

dependencies += magick

targets += cs.pdf

vpath a7%.tex characters

include config/common.mk

WARREN = main.tex commands.tex images/ glossary.tex intro.tex invasion.tex $(wildcard warren_*.tex) appendix.tex handouts.tex appendix.tex images/extracted/lower-handout.svg $(MAP_PARTS)

UPPER_WARREN = $(WARREN) top.tex tour.tex images/extracted/upper-handout.svg

OUTSIDE_WARREN = $(UPPER_WARREN) module.tex sq.tex

config/common.mk:
	git submodule update --init

MAP_PARTS = images/extracted/lower-1.jpg images/extracted/lower-2.jpg images/extracted/lower-3.jpg

LOWER_SECTION_1_RECTS = magick - -fill white -channel-fx '| gray=>alpha' \
	-draw "rectangle 1680,0 2460,190" $@

LOWER_SECTION_2_RECTS = magick - -fill white -channel-fx '| gray=>alpha' \
	-draw "rectangle 0,0 1000,900" \
	-draw "rectangle 0,0 2000,300" \
	-draw "rectangle 0,0 1330,460" \
	-draw "rectangle 0,0 1100,480" \
	$@

LOWER_SECTION_3_RECTS = magick - -fill white -channel-fx '| gray=>alpha' \
	-draw "rectangle 1370,935 2320,1360" \
	-draw "rectangle 1500,925 2320,1360" \
	-draw "rectangle 1350,1330 2320,1360" \
	-draw "rectangle 1720,805 2320,1360" \
	-draw "rectangle 2100,770 2320,1360" \
	$@

# These three images are the lower map, divided.
images/extracted/lower-1.jpg: images/Dyson_Logos/lower.svg images/extracted/
	cat $< | inkscape --pipe \
	--export-type=png --export-area=159:1936:3020:3039 | \
	$(LOWER_SECTION_1_RECTS)
images/extracted/lower-2.jpg: images/Dyson_Logos/lower.svg images/extracted/
	cat $< | inkscape --pipe \
	--export-type=png --export-area=422:502:3463:2133 | \
	$(LOWER_SECTION_2_RECTS)
images/extracted/lower-3.jpg: images/Dyson_Logos/lower.svg images/extracted/
	cat $< | inkscape --pipe \
	--export-type=png --export-area=30:40:2350:1400 | \
	$(LOWER_SECTION_3_RECTS)

# These three are for player handouts, as they cut out the goblin icons.
images/extracted/lower-handout-1.jpg: images/Dyson_Logos/lower.svg images/extracted/
	cat $< | inkscape --pipe \
	--select=layer2 --actions=delete \
	--export-type=png --export-area=159:1936:3020:3039 | \
	$(LOWER_SECTION_1_RECTS)

images/extracted/lower-handout-2.jpg: images/Dyson_Logos/lower.svg images/extracted/
	cat $< | inkscape --pipe \
	--select=layer2 --actions=delete \
	--export-type=png --export-area=422:502:3463:2133 | \
	$(LOWER_SECTION_2_RECTS)

images/extracted/lower-handout-3.jpg: images/Dyson_Logos/lower.svg images/extracted/
	cat $< | inkscape --pipe \
	--select=layer2 --actions=delete \
	--export-type=png --export-area=30:40:2350:1400 | \
	$(LOWER_SECTION_3_RECTS)

images/extracted/upper-handout.svg: images/Dyson_Logos/upper.svg images/extracted/
	inkscape $< --export-id-only --export-id=layer3 -l --export-filename $@

images/extracted/lower-handout.svg: images/Dyson_Logos/lower.svg images/extracted/
	inkscape $< --select=layer2 --actions=delete -l --export-filename $@

config/rules.pdf:
	make -C config rules.pdf

$(DBOOK): $(DEPS) $(WARREN) $(MAP_PARTS) .switch-gls
$(TITLE).pdf: $(DROSS)/$(BOOK).pdf $(DROSS)/characters.pdf config/rules.pdf
	pdfunite $^ $@

$(DROSS)/extended_$(BOOK).pdf: $(DEPS) $(UPPER_WARREN)
	@$(COMPILER) -jobname=extended_$(BOOK) main.tex
Extended_$(TITLE).pdf: $(DROSS)/extended_$(BOOK).pdf $(DROSS)/characters.pdf
	pdfunite $^ $@

$(DROSS)/hardcore_$(BOOK).pdf: $(DEPS) $(OUTSIDE_WARREN)
	@$(COMPILER) -jobname=hardcore_$(BOOK) module.tex
Hardcore_$(TITLE).pdf: $(DROSS)/hardcore_$(BOOK).pdf
	@$(CP) $< $@

